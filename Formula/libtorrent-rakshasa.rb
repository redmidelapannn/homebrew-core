class LibtorrentRakshasa < Formula
  desc "BitTorrent library for rTorrent"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.9.7/libtorrent-0.13.7.tar.gz"
  sha256 "c738f60f4d7b6879cd2745fb4310bf24c9287219c1fd619706a9d5499ca7ecc1"

  bottle do
    cellar :any
    sha256 "8a627c2b6228b6f2ac59f7d9f99e0e198f1e671159033f7a9b8ed5f2033fccbf" => :mojave
    sha256 "eafd1112699f4bb3721df5e2aef7e4f6e1015bbafdf8b51daeb4e33563fac0ea" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "cppunit"
  depends_on "openssl"

  conflicts_with "libtorrent-rasterbar", :because => "both install the same binaries"

  def install
    args = ["--with-kqueue", "--prefix=#{prefix}"]

    system "sh", "autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"sample.cc").write <<~EOS
      #include <iostream>
      #include <torrent/torrent.h>
      int main(int argc, char* *argv)
      {
        std::cout << torrent::version();
        return 0;
      }
    EOS

    system ENV.cxx, "-o", "sample", "sample.cc", "-ltorrent"
    system "./sample"
  end
end
