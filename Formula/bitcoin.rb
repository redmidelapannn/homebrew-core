class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoin.org/"
  url "https://github.com/bitcoin/bitcoin/archive/v0.14.2.tar.gz"
  sha256 "e0ac23f01a953fcc6290c96799deeffb32aa76ca8e216c564d20c18e75a25219"
  revision 2
  head "https://github.com/bitcoin/bitcoin.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7bec398fb9a108bdce575c2da053e0e8354f821fa4f6e00198cec67d09d37d24" => :high_sierra
    sha256 "8bbfd9f97f4561369c9f3e4ede0892311053b7666bb7ec38f129fa2ff5578990" => :sierra
    sha256 "961cb5106d1e3ed4b6ce84b2324fc7025ba905432013e044004693904b6d4800" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db@4"
  depends_on "boost"
  depends_on "libevent"
  depends_on "miniupnpc"
  depends_on "openssl"

  needs :cxx11

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  plist_options :manual => "bitcoind"

  def plist; <<-EOS.undent
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
