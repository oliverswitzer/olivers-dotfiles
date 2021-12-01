. /opt/homebrew/opt/asdf/libexec/asdf.sh

eval "$(/opt/homebrew/bin/brew shellenv)"

export KERL_CONFIGURE_OPTIONS="--disable-debug --disable-silent-rules --enable-darwin-64bit --enable-dynamic-ssl-lib --enable-hipe --enable-kernel-poll --enable-shared-zlib --enable-smp-support --enable-threads --enable-wx --with-dynamic-trace=dtrace --with-ssl=/opt/homebrew/opt/openssl@1.1 --with-wx-config=/opt/homebrew/opt/wxmac@3.1/bin/wx-config --without-javac"
export PATH="$HOME/.cargo/bin:$PATH"
