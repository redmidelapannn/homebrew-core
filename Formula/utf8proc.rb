class Utf8proc < Formula
  desc "Clean C library for processing UTF-8 Unicode data"
  homepage "https://julialang.org/utf8proc/"
  url "https://github.com/JuliaLang/utf8proc/archive/v2.1.tar.gz"
  sha256 "241c409d8f6c0e4f332e41f3f1bd39552e36dcc00084fbacd03682b2969a301e"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2d8be55e740d5edbdebbc59cdd2eaabc08ee3a090ae1b8bb9aea54e898cdb9a2" => :sierra
    sha256 "077440f8777e268fdb8cda0cf9aeb7b2a4750f8e15bd782af8f0981dd8d77dec" => :el_capitan
    sha256 "851f60605bec80c1c9f1c86ee490d3d1cc0f47c8306240a7eb98480afcaf6e47" => :yosemite
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <string.h>
      #include <utf8proc.h>

      int main() {
        const char *version = utf8proc_version();
        return strnlen(version, sizeof("1.3.1-dev")) > 0 ? 0 : -1;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lutf8proc", "-o", "test"
    system "./test"
  end
end
