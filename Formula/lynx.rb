class Lynx < Formula
  desc "Text-based web browser"
  homepage "http://invisible-island.net/lynx/"
  url "http://invisible-mirror.net/archives/lynx/tarballs/lynx2.8.8rel.2.tar.bz2"
  version "2.8.8rel.2"
  sha256 "6980e75cf0d677fd52c116e2e0dfd3884e360970c88c8356a114338500d5bee7"
  revision 1

  bottle do
    rebuild 2
    sha256 "cde9272d8c95201aec06d9427f821318ea148375d2e89e817c071362aa442fae" => :sierra
    sha256 "18abc8995b6cc3d1a6b5120ec1b001c2d3a3379292376c93a83d7da3c6e72d2a" => :el_capitan
    sha256 "16dfd34d20e71dff99f361cc24adfd9f13c33bd50e025ac2da2f6ca4e326528a" => :yosemite
  end

  depends_on "openssl"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-echo",
                          "--enable-default-colors",
                          "--with-zlib",
                          "--with-bzlib",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}",
                          "--enable-ipv6"
    system "make", "install"
  end

  test do
    system "#{bin}/lynx", "-dump", "https://example.org/"
  end
end
