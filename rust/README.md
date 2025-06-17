## 安装

1. `mkdir -p ${CARGO_HOME} ${RUSTUP_HOME}`
2. `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`

## 配置

- fish: 安装之后，会自动创建 ~/.config/fish/conf.d/rustup.fish；可以考虑将 rustup.fish 拷贝到 $FISH_HOME/etc/fish/conf.d/
- zsh: 安装之后，会自动在 ~/.zshenv 追加 `. $CARGO_HOME/env`，删除该语句

## 卸载

1. `rustup self uninstall`
2. `rm -rf ${CARGO_HOME} ${RUSTUP_HOME}`

## musl 编译

### 使用 cross 编译

1. 安装 docker
2. `cross build --target x86_64-unknown-linux-musl`

### 使用 alpine 编译

1. 参照 alpine 章节

### 使用命令编译

- 注意区分是编译 C++ 还是 C：`cp ./config.toml /path/to/project/.cargo/ && TARGET_CC=x86_64-linux-musl-gcc cargo build --release --target x86_64-unknown-linux-musl`
- `RUSTFLAGS="-C target-feature=+crt-static" CROSS_COMPILE=x86_64-linux-musl- cargo build --target x86_64-unknown-linux-musl`
