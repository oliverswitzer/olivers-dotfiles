#!/usr/bin/env zsh

ARCHITECTURE=$(uname -m)

if [ "$ARCHITECTURE" = "x86_64" ]; then
  :
elif [ "$ARCHITECTURE" = "arm64" ]; then
  . /opt/homebrew/opt/asdf/libexec/asdf.sh

  # Mysterious evil forces are adding homebrew to path too early
  export PATH="$(echo $PATH | sed 's/\/opt\/homebrew\/[^:]*://g')"
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export LIBRARY_PATH=/opt/homebrew/lib
  export CPATH=/opt/homebrew/include

  # Necessary for compiling Erlang on M1 macs
  export KERL_CONFIGURE_OPTIONS="--disable-debug --disable-silent-rules --enable-darwin-64bit --enable-dynamic-ssl-lib --enable-hipe --enable-kernel-poll --enable-shared-zlib --enable-smp-support --enable-threads --enable-wx --with-dynamic-trace=dtrace --with-ssl=/opt/homebrew/opt/openssl@1.1 --with-wx-config=/opt/homebrew/opt/wxmac@3.1/bin/wx-config --without-javac"
fi


export PATH="$HOME/.cargo/bin:$PATH"
