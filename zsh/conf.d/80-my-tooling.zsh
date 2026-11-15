# Short tool initializers. Applications with substantial custom logic should
# graduate to their own numbered configuration file.

# Rust
[ -s "${CARGO_HOME}/env" ] && \. "${CARGO_HOME}/env"

# Node.js
[ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"

# Prompt
# zsh reserves one column to the right of RPROMPT by default. Starship's
# two-line border must be flush with the first line and fish's right prompt.
typeset -g ZLE_RPROMPT_INDENT=0
hash starship &>/dev/null && eval "$(starship init zsh)"

# CmdIME
[[ -x '/Applications/CmdIME.app/Contents/MacOS/keyboardctl' ]] && eval "$('/Applications/CmdIME.app/Contents/MacOS/keyboardctl' shell-init zsh)"

# Command correction
hash thefuck &>/dev/null && eval "$(thefuck --alias)"

# Directory navigation
hash zoxide &>/dev/null && eval "$(zoxide init --cmd cd zsh)"
