# XDG
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx XDG_CONFIG_DIRS "/etc/xdg"
set -gx XDG_DATA_DIRS "/usr/local/share:/usr/share"

# go
set -gx GOROOT "/opt/go"
set -gx GOPATH "$HOME/project/go"

# rust
set -gx CARGO_HOME "/opt/cargo"
set -gx RUSTUP_HOME "/opt/rustup"
set -gx RUSTUP_DIST_SERVER "https://mirrors.tuna.tsinghua.edu.cn/rustup"
set -gx RUSTUP_UPDATE_ROOT "https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup"

# nvm
set -gx NVM_DIR "/opt/nvm"
set -gx NVM_NODEJS_ORG_MIRROR "http://nodejs.org/dist"

# homebrew
set -gx HOMEBREW_BREW_GIT_REMOTE "https://mirrors.ustc.edu.cn/brew.git"
set -gx HOMEBREW_CORE_GIT_REMOTE "https://mirrors.ustc.edu.cn/homebrew-core.git"
set -gx HOMEBREW_API_DOMAIN "https://mirrors.ustc.edu.cn/homebrew-bottles/api"
set -gx HOMEBREW_API_DOMAIN "https://mirrors.ustc.edu.cn/homebrew-bottles/api"
set -gx HOMEBREW_BOTTLE_DOMAIN "https://mirrors.ustc.edu.cn/homebrew-bottles/bottles"

# systemtap
set -gx SYSTEMTAP_DIR "$XDG_CACHE_HOME/systemtap"

# nvidia
set -gx __GL_SHADER_DISK_CACHE_PATH "$XDG_CACHE_HOME/nv"

# gnupg
set -gx GNUPGHOME "$XDG_CONFIG_HOME/gnupg"

# fisher
set -gx fisher_path "/opt/fish/etc/fish/plugin"

# path
set -gx PATH "$CARGO_HOME/bin:$GOROOT/bin:$PATH"

# man
set -gx MANPAGER "sh -c 'col -bx | bat -l man --style=plain --paging=always'"
set -gx MANROFFOPT "-c"

# language
set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8
set -gx LANGUAGE en_US.UTF-8
