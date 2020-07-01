#!/bin/bash

set -euxo pipefail

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd "$CWD"

export DEBIAN_FRONTEND=noninteractive

apt-get update

# required for zsh
apt-get install -y --no-install-recommends zsh curl wget git

# oh-my-zsh and plugins
ZSH_RT=~/.oh-my-zsh
[ ! -d "$ZSH_RT" ] && wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O /tmp/install-oh-my-zsh.sh && zsh /tmp/install-oh-my-zsh.sh --unattended && rm -vf /tmp/install-oh-my-zsh.sh

ZSH_AS=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
[ ! -d "$ZSH_AS" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_AS"
chsh -s "$(which zsh)"

# deploy dotfiles
cp -rv dotfiles/. ~/

# developer toolchain
apt-get install -y --no-install-recommends \
    apt-utils software-properties-common apt-transport-https ca-certificates \
    vim tmux time less openssh-client tig gpg-agent git-lfs unrar zip unzip p7zip-full \
    htop iftop sysstat iotop rsync vnstat fail2ban lynx jq tzdata neofetch autojump \
    iproute2 iputils-ping iputils-tracepath dnsutils net-tools ngrep netcat telnet \
    gcc g++ build-essential libssl-dev libffi-dev imagemagick cowsay lolcat figlet

# set timezone
export TZ='Asia/Shanghai'
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# git init
git lfs install

# azure tools
wget -q -O az.tgz https://aka.ms/downloadazcopy-v10-linux && tar -vzxf az.tgz
AZ_DIR=$(find -name "azcopy_linux_amd64_10*" -type d | head -n 1)
[ -d "$AZ_DIR" ] && mv -v "$AZ_DIR"/azcopy /usr/local/bin && rm -fr "$AZ_DIR" az.tgz

# jq
curl -sL https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -o jq
chmod +x jq && mv -v jq /usr/bin

# fzf
[ ! -d ~/.fzf ] && git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --bin --64 --no-key-bindings --completion

# python
add-apt-repository ppa:deadsnakes/ppa -y && apt-get update
apt-get install -y --no-install-recommends python3-dev python3-pip python3-setuptools python3-distutils python3.8-dev
python3.8 -m pip install -U pip setuptools

# go
GO_PATH=/go
GO_VERSION=1.14.4
OS=linux
ARCH=amd64
mkdir -p "$GO_PATH"
wget -q -O go.tgz "https://dl.google.com/go/go${GO_VERSION}.${OS}-${ARCH}.tar.gz" && echo "aed845e4185a0b2a3c3d5e1d0a35491702c55889192bb9c30e67a3de6849c067 *go.tgz" | sha256sum -c -
tar -C /usr/local -xzf go.tgz && rm -f go.tgz

export GOPATH=/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN:/usr/local/go/bin
go get github.com/zb64/zb64
go get github.com/sqs/goreturns
go get golang.org/x/tools/cmd/goimports

echo "Done"
cd ~
