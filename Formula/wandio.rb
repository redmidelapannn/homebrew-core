class Wandio < Formula
  desc "Transparently read from and write to zip, bzip2, lzma or zstd archives"
  homepage "https://research.wand.net.nz/software/libwandio.php"
  url "https://research.wand.net.nz/software/wandio/wandio-4.0.0.tar.gz"
  sha256 "f6d9c81c1ad0b7a99696c057fb02e5c04a9c240effd6bf587a5b02352ce86a9f"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f2636969bf8dea3ccaf9524bbcee033ddf8f1f68419017d43cbe833f62e1999a" => :mojave
    sha256 "116210447c3b1f9c5015e8d35b6535a5281da5621ad1873275a31f4d03f2cb04" => :high_sierra
    sha256 "d6ab7d21487a93f161cec0696229039d9dcb97fb552e056aafdfb42621a9142d" => :sierra
  end

  def install
    system "./configure", "--disable-debug",
                          "--with-http",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/wandiocat", "-h"
  end
end
