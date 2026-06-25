#!/usr/bin/env python3

import json
import os
import subprocess
import sys
import re
import urllib.request
import urllib.error
import time
import fcntl
from pathlib import Path


RESET     = "\033[0m"
BOLD      = "\033[1m"
GRAY      = "\033[38;2;150;152;150m"
RED       = "\033[38;2;204;102;102m"
ORANGE    = "\033[38;2;222;147;95m"
YELLOW    = "\033[38;2;240;198;116m"
GREEN     = "\033[38;2;181;189;104m"
CYAN      = "\033[38;2;138;190;183m"
BLUE      = "\033[38;2;129;162;190m"
PURPLE    = "\033[38;2;178;148;187m"
WHITE     = "\033[38;2;197;200;198m"


CLAUDE_DIR        = Path.home() / ".claude"
CACHE_FILE        = CLAUDE_DIR / "statusline_cache.json"
LOCK_FILE         = CLAUDE_DIR / "statusline_cache.lock"


GIT_CACHE_TTL     = 8.0
BALANCE_CACHE_TTL = 8.0
GIT_TIMEOUT       = 0.5
HTTP_TIMEOUT      = 3.0


def human(n):
    try:
        n = int(n)
    except:
        return "0"
    if n >= 1_000_000_000:
        return f"{n/1_000_000_000:.1f}B"
    if n >= 1_000_000:
        return f"{n/1_000_000:.1f}M"
    if n >= 1_000:
        return f"{n/1_000:.1f}K"
    return str(n)


def read_cache():
    if not CACHE_FILE.exists():
        return {}
    try:
        with open(LOCK_FILE, "w") as lock:
            fcntl.flock(lock, fcntl.LOCK_SH)
            with open(CACHE_FILE, "r", encoding="utf-8") as f:
                data = json.load(f)
            fcntl.flock(lock, fcntl.LOCK_UN)
        return data
    except (json.JSONDecodeError, OSError, PermissionError):
        return {}


def write_cache(data):
    tmp = CACHE_FILE.with_suffix(".tmp")
    try:
        with open(LOCK_FILE, "w") as lock:
            fcntl.flock(lock, fcntl.LOCK_EX)
            with open(tmp, "w", encoding="utf-8") as f:
                json.dump(data, f)
            os.replace(tmp, CACHE_FILE)
            fcntl.flock(lock, fcntl.LOCK_UN)
    except OSError:
        pass


def fetch_git_status(cwd):
    """在指定工作目录下执行 git 命令，返回状态字典"""
    status = {
        "branch": "",
        "staged": 0,
        "modified": 0,
        "deleted": 0,
        "renamed": 0,
        "untracked": 0,
        "conflicted": 0,
        "ahead": 0,
        "behind": 0,
        "stashed": 0,
    }

    try:
        output = subprocess.check_output(
            ["git", "status", "--porcelain", "-b"],
            stderr=subprocess.DEVNULL,
            text=True,
            timeout=GIT_TIMEOUT,
            cwd=cwd
        ).strip()

        if output:
            lines = output.split("\n")
            if lines and lines[0].startswith("## "):
                branch_line = lines[0][3:]
                if branch_line.startswith("No commits yet on "):
                    status["branch"] = branch_line[len("No commits yet on "):]
                else:
                    if "..." in branch_line:
                        local, remote = branch_line.split("...", 1)
                        status["branch"] = local
                        if "[" in remote and "]" in remote:
                            remote_info = remote.split("[", 1)[1].split("]", 1)[0]
                            if "ahead" in remote_info:
                                ahead_match = re.search(r"ahead (\d+)", remote_info)
                                if ahead_match:
                                    status["ahead"] = int(ahead_match.group(1))
                            if "behind" in remote_info:
                                behind_match = re.search(r"behind (\d+)", remote_info)
                                if behind_match:
                                    status["behind"] = int(behind_match.group(1))
                    else:
                        status["branch"] = branch_line

                for line in lines[1:]:
                    if not line:
                        continue
                    x = line[0]
                    y = line[1]
                    if x == "R" or x == "C":
                        status["renamed"] += 1
                    elif x == "A" or x == "M" or x == "D":
                        status["staged"] += 1
                    elif x == "U" or x == "D" or x == "A" or x == "M":
                        status["conflicted"] += 1
                    if y == "M":
                        status["modified"] += 1
                    elif y == "D":
                        status["deleted"] += 1
                    elif y == "?":
                        status["untracked"] += 1
                    elif y == "U" or y == "A" or y == "D":
                        status["conflicted"] += 1

        try:
            stash_count = subprocess.check_output(
                ["git", "rev-list", "--count", "refs/stash"],
                stderr=subprocess.DEVNULL,
                text=True,
                timeout=GIT_TIMEOUT,
                cwd=cwd
            ).strip()
            if stash_count and stash_count != "0":
                status["stashed"] = int(stash_count)
        except (subprocess.CalledProcessError, subprocess.TimeoutExpired):
            pass

    except (subprocess.CalledProcessError, subprocess.TimeoutExpired, FileNotFoundError):
        pass

    return status


def git_status(cwd=None):
    """根据工作目录获取 Git 状态，使用独立缓存（键为绝对路径）"""
    now = time.time()
    if cwd:
        cwd_key = str(Path(cwd).resolve())
    else:
        cwd_key = os.getcwd()

    cache = read_cache()
    # 确保 git 缓存是字典
    if "git" not in cache or not isinstance(cache["git"], dict):
        cache["git"] = {}

    entry = cache["git"].get(cwd_key)
    if entry and entry.get("timestamp", 0) + GIT_CACHE_TTL > now:
        return entry.get("data", {})

    # 获取新状态
    status = fetch_git_status(cwd_key)
    cache["git"][cwd_key] = {"timestamp": now, "data": status}
    write_cache(cache)
    return status


def format_git_status(status):
    if not status or not status.get("branch"):
        return ""
    symbols = {
        "staged": "+",
        "modified": "!",
        "deleted": "x",
        "renamed": "r",
        "untracked": "?",
        "conflicted": "=",
        "ahead": "↑",
        "behind": "↓",
        "stashed": "≡",
    }
    parts = []
    if status.get("conflicted", 0) > 0:
        parts.append(f"{RED}{symbols['conflicted']}{status['conflicted']}{RESET}")
    if status.get("untracked", 0) > 0:
        parts.append(f"{RED}{symbols['untracked']}{status['untracked']}{RESET}")
    if status.get("modified", 0) > 0:
        parts.append(f"{RED}{symbols['modified']}{status['modified']}{RESET}")
    if status.get("staged", 0) > 0:
        parts.append(f"{GREEN}{symbols['staged']}{status['staged']}{RESET}")
    if status.get("renamed", 0) > 0:
        parts.append(f"{BLUE}{symbols['renamed']}{status['renamed']}{RESET}")
    if status.get("deleted", 0) > 0:
        parts.append(f"{RED}{symbols['deleted']}{status['deleted']}{RESET}")
    ahead_behind = ""
    ahead = status.get("ahead", 0)
    behind = status.get("behind", 0)
    if ahead > 0 and behind > 0:
        ahead_behind = f"{YELLOW}{symbols['ahead']}{ahead}{symbols['behind']}{behind}{RESET}"
    elif ahead > 0:
        ahead_behind = f"{YELLOW}{symbols['ahead']}{ahead}{RESET}"
    elif behind > 0:
        ahead_behind = f"{YELLOW}{symbols['behind']}{behind}{RESET}"
    stashed = ""
    if status.get("stashed", 0) > 0:
        stashed = f"{PURPLE}{symbols['stashed']}{status['stashed']}{RESET}"
    status_str = "".join(parts)
    if ahead_behind:
        status_str += ahead_behind
    if stashed:
        status_str += stashed
    branch_display = f"{GRAY}{status['branch']}{RESET}"
    if status_str:
        return f"{branch_display} {status_str}"
    else:
        return branch_display


def get_deepseek_balance(model_name):
    if not model_name or "deepseek" not in model_name.lower():
        return None

    now = time.time()
    cache = read_cache()
    balance_cache = cache.get("balance", {})
    if balance_cache.get("timestamp", 0) + BALANCE_CACHE_TTL > now:
        return balance_cache.get("data")

    api_key = os.environ.get("DEEPSEEK_API_KEY") or os.environ.get("ANTHROPIC_AUTH_TOKEN")
    if not api_key:
        cache["balance"] = {"timestamp": now, "data": None}
        write_cache(cache)
        return None

    balance = None
    try:
        req = urllib.request.Request(
            "https://api.deepseek.com/user/balance",
            headers={
                "Authorization": f"Bearer {api_key}",
                "Accept": "application/json"
            }
        )
        with urllib.request.urlopen(req, timeout=HTTP_TIMEOUT) as resp:
            data = json.loads(resp.read().decode())
            if data.get("is_available"):
                for info in data.get("balance_infos", []):
                    if info.get("currency") == "CNY":
                        balance = info.get("total_balance")
                        break
    except Exception:
        pass

    cache = read_cache()
    cache["balance"] = {"timestamp": now, "data": balance}
    write_cache(cache)
    return balance


try:
    data = json.load(sys.stdin)
except:
    sys.exit(0)

model         = (data.get("model") or {}).get("display_name") or "unknown"
effort        = (data.get("effort") or {}).get("level") or "unknown"
style         = (data.get("output_style") or {}).get("name") or "unknown"
session_id    = data.get("session_id") or "default"
cwd           = data.get("cwd") or ""
ctx_win       = data.get("context_window") or {}
ctx_used_pct  = ctx_win.get("used_percentage") or 0
ctx_size      = ctx_win.get("context_window_size") or 0

git_info      = git_status(cwd=cwd)  # 传入工作目录
git_text      = format_git_status(git_info)

balance       = get_deepseek_balance(model)

line1 = (
    f"{RESET}Model: {BLUE}{BOLD}{model}{RESET} | "
    f"{RESET}Effort: {PURPLE}{effort}{RESET} | "
    f"{RESET}Style: {CYAN}{style}{RESET} | "
    f"{RESET}Context: {CYAN}{ctx_used_pct}%{RESET}, {BLUE}{human(ctx_size)}{RESET}"
)

if balance is not None:
    line1 += f" | Balance: {GREEN}CNY {balance}{RESET}"

if git_text:
    line1 += f" | {RESET}{git_text}{RESET}"

print(line1)
