## 安装

- MacOS:
  1. `brew install aria2`
- Linux:
  1. `aptitude install libgnutls28-dev nettle-dev libgmp-dev libssh2-1-dev libc-ares-dev libxml2-dev zlib1g-dev libsqlite3-dev pkg-config libgpg-error-dev libgcrypt-dev libssl-dev libexpat1-dev libxml2-dev libcppunit-dev libtool autoconf automake autotools-dev autopoint libtool`
  2. `autoreconf -i`
  3. `./configure --with-ca-bundle='/etc/ssl/certs/ca-certificates.crt'`
  4. `make`
  5. `make install`

## 用例

`aria2c -d /root -o name`
