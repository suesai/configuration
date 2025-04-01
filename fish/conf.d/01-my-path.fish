# fish
set -gx FISH_HOME                /opt/fish

# go
set -gx GOROOT                   /opt/go
set -gx GOPATH                   $HOME/project/go

# kitty
set -gx KITTY_HOME               /opt/kitty

# nvim
set -gx NVIM_HOME                /opt/nvim

# nvm
set -gx NVM_DIR                  /opt/nvm

# rust
set -gx CARGO_HOME               /opt/cargo
set -gx RUSTUP_HOME              /opt/rustup

# path
if not contains $CARGO_HOME/bin $PATH
	set -gx PATH             $PATH $CARGO_HOME/bin $FISH_HOME/bin $GOROOT/bin $KITTY_HOME/bin $NVIM_HOME/bin
end
