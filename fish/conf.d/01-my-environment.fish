# xdg
set -gx XDG_CACHE_HOME           "$HOME/.cache"
set -gx XDG_CONFIG_HOME          "$HOME/.config"
set -gx XDG_DATA_HOME            "$HOME/.local/share"
set -gx XDG_STATE_HOME           "$HOME/.local/state"

# fish
set -gx FISH_HOME                "/opt/fish"

# gnupg
set -gx GNUPGHOME                "$XDG_CONFIG_HOME/gnupg"

# go
set -gx GOROOT                   "/opt/go"
set -gx GOPATH                   "$HOME/project/go"

# homebrew
set -gx HOMEBREW_API_DOMAIN      "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
set -gx HOMEBREW_BOTTLE_DOMAIN   "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
set -gx HOMEBREW_BREW_GIT_REMOTE "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
set -gx HOMEBREW_CORE_GIT_REMOTE "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"

# kitty
set -gx KITTY_HOME               "/opt/kitty"

# nvidia
set -gx __GL_SHADER_DISK_CACHE_PATH "$XDG_CACHE_HOME/nv"

# nvim
set -gx NVIM_HOME                "/opt/nvim"

# nvm
set -gx NVM_DIR                  "/opt/nvm"
set -gx NODE_MIRROR              "https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/"
set -gx NVM_NODEJS_ORG_MIRROR    "https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/"

# rust
set -gx CARGO_HOME               "/opt/cargo"
set -gx RUSTUP_HOME              "/opt/rustup"
set -gx RUSTUP_DIST_SERVER       "https://mirrors.tuna.tsinghua.edu.cn/rustup"
set -gx RUSTUP_UPDATE_ROOT       "https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup"

# systemtap
set -gx SYSTEMTAP_DIR            "$XDG_CACHE_HOME/systemtap"

# path
if not contains $CARGO_HOME/bin $PATH
	set -gx PATH             $PATH $CARGO_HOME/bin $FISH_HOME/bin $GOROOT/bin $KITTY_HOME/bin $NVIM_HOME/bin
end

# man
set -gx MANPAGER                 "sh -c 'col -bx | bat -l man --style=plain --paging=always'"
set -gx MANROFFOPT               "-c"

# editor
set -gx EDITOR                   "nvim"

# language
set -gx LC_ALL                   "en_US.UTF-8"
set -gx LANG                     "en_US.UTF-8"
set -gx LANGUAGE                 "en_US.UTF-8"
