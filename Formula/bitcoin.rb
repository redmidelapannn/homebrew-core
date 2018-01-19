class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoin.org/"

  stable do
    url "https://bitcoin.org/bin/bitcoin-core-0.15.1/bitcoin-0.15.1.tar.gz"
    sha256 "34de2dbe058c1f8b6464494468ebe2ff0422614203d292da1c6458d6f87342b4"

    # Boost 1.66 compat
    # Upstream commit 7 Dec 2017 "Make boost::multi_index comparators const"
    patch do
      url "https://github.com/bitcoin/bitcoin/commit/1ec0c0a01c31.patch?full_index=1"
      sha256 "a1f761fe29f78e783cb4b55f8029900f94b45d1188cb81c80f73347ee2fdc025"
    end
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "b24fc932962989670c2177320ac844952de4081d9b92ddac9c36a57cacad347d" => :high_sierra
    sha256 "a363fec5845a9b787c3bbab8ef57633427e020d6ae3d0b95e4e04e3e942b1c17" => :sierra
    sha256 "23ecacb0499e0216bb19c5cd35af8b48dfe6e210588ce16f125fd022fdb086d9" => :el_capitan
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
