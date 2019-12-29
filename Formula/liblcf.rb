class Liblcf < Formula
  desc "Library for RPG Maker 2000/2003 games data"
  homepage "https://easyrpg.org/"
  url "https://github.com/EasyRPG/liblcf/archive/0.6.1.tar.gz"
  sha256 "224068ede007098d8fad45348da3b47f00a33d5e8a4a693514d5c9290ab1883f"
  revision 1
  head "https://github.com/EasyRPG/liblcf.git"

  bottle do
    cellar :any
    sha256 "78a9c0ce4e836de21884c5779dc03a541fa598f210b604a5794825a4b089dd3a" => :catalina
    sha256 "29e045f2a30a5bf828552a18653e7453682ed8b20f8c89550bdcd8a0ba5ec0f0" => :mojave
    sha256 "dce6c30cd900f659b701b7272d050c4494bdd9b4eb2517208fc7e39bef25f38d" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "expat"
  depends_on "icu4c"

  def install
    system "autoreconf", "-i"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "lsd_reader.h"
      #include <cassert>

      int main() {
        std::time_t const current = std::time(NULL);
        assert(current == LSD_Reader::ToUnixTimestamp(LSD_Reader::ToTDateTime(current)));
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}/liblcf", "-L#{lib}", "-llcf", "-std=c++11", \
      "-o", "test"
    system "./test"
  end
end
