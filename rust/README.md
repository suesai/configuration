## 安装

1. 确保 CARGO_HOME，RUSTUP_HOME 环境变量存在
2. `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`

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
