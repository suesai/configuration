FROM alpine:latest

ENV GOPROXY=https://goproxy.cn,direct
ENV NODE_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/
ENV NVM_NODEJS_ORG_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/
ENV RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup
ENV RUSTUP_UPDATE_ROOT=https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup

WORKDIR /root/

RUN echo "https://mirrors.tuna.tsinghua.edu.cn/alpine/latest-stable/main"       >/etc/apk/repositories
RUN echo "https://mirrors.tuna.tsinghua.edu.cn/alpine/latest-stable/community" >>/etc/apk/repositories
RUN apk update
RUN apk upgrade
RUN apk add --no-cache vim bash bind-tools shadow
RUN apk add --no-cache alpine-sdk cmake go nodejs npm gdb strace automake autoconf
RUN curl –proto '=https' –tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN chsh -s bash

CMD ["/bin/bash", "--login"]
