class Rtorrent < Formula
  desc "Console-based BitTorrent client"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.9.7/rtorrent-0.9.7.tar.gz"
  sha256 "5d9842fe48c9582fbea2c7bf9f51412c1ccbba07d059b257039ad53b863fe8bb"

  bottle do
    sha256 "587174ee61d8a3ab49fb25e802c81aea6566e13f41629ad87b81029558979663" => :mojave
    sha256 "a288d64abb9d5967562ff4b0257dac5b77dd7a5c3382a277c5fbe02ee6545193" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "cppunit"
  depends_on "libsigc++"
  depends_on "libtorrent-rakshasa"
  depends_on "openssl"
  depends_on "xmlrpc-c"

  def install
    # Fix file not found errors for /usr/lib/system/libsystem_darwin.dylib
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    ENV.append "LDFLAGS", "-L/usr/local/opt/openssl/lib -lcrypto"

    args = ["--with-xmlrpc-c", "--prefix=#{prefix}"]

    system "sh", "autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"

    doc.install "doc/rtorrent.rc"
  end

  test do
    system "#{bin}/rtorrent", "-h"
  end
end
