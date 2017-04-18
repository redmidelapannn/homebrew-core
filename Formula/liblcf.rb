class Liblcf < Formula
  desc "Library for RPG Maker 2000/2003 games data"
  homepage "https://easyrpg.org/"
  url "https://github.com/EasyRPG/liblcf/archive/0.5.1.tar.gz"
  sha256 "3214fe524186c3d10a09c947f0a9aa36d262871b7134a9e7653610fcdd4b44b2"
  revision 1
  head "https://github.com/EasyRPG/liblcf.git"

  bottle do
    cellar :any
    sha256 "748aa8d5c0df2be53afb29edb6e7575521870b5bbd7a66f60c39908ac999f3b8" => :sierra
    sha256 "ac8517f8c1ed621ec1128498b39075814ad1b7ec42ead78030e0bd105756ebcc" => :el_capitan
    sha256 "453e11519bf4e9d2534d6f03f37b95fa261338beb2b73d1cced8b78ce1a371b4" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "expat"

  def install
    system "autoreconf", "-i"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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
