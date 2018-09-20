class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoin.org/"
  url "https://bitcoin.org/bin/bitcoin-core-0.16.3/bitcoin-0.16.3.tar.gz"
  sha256 "836eed97dfc79cff09f356e8fbd6a6ef2de840fb9ff20ebffb51ccffdb100218"

  bottle do
    cellar :any
    sha256 "7dc0121b6ebf41ccd4fc57591849c2098e0f3fca7747ea1cc5cb415e2828fa18" => :mojave
    sha256 "2593f59234fb49f86d28ba6148cce11b3fe3e3452523c6e90eafd7647e8678ff" => :high_sierra
    sha256 "808f27f4c0edb25b0e85b50e702837a1d38e37e29685df36fc2e357cd879de3c" => :sierra
    sha256 "d9ead8063642006a0cc3ec7bb57900239f55beba42a1b166500104114f35ecfb" => :el_capitan
  end

  head do
    url "https://github.com/bitcoin/bitcoin.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "berkeley-db@4"
  depends_on "boost"
  depends_on "libevent"
  depends_on "miniupnpc"
  depends_on "openssl"
  depends_on "zeromq"

  needs :cxx11

  def install
    if MacOS.version == :el_capitan && MacOS::Xcode.installed? &&
       MacOS::Xcode.version >= "8.0"
      ENV.delete("SDKROOT")
    end

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "share/rpcauth"
  end

  plist_options :manual => "bitcoind"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/bitcoind</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
  EOS
  end

  test do
    system "#{bin}/test_bitcoin"
  end
end
