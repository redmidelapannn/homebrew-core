class Utf8proc < Formula
  desc "Clean C library for processing UTF-8 Unicode data"
  homepage "https://juliastrings.github.io/utf8proc/"
  url "https://github.com/JuliaStrings/utf8proc/archive/v2.2.0.tar.gz"
  sha256 "3f8fd1dbdb057ee5ba584a539d5cd1b3952141c0338557cb0bdf8cb9cfed5dbf"

  bottle do
    cellar :any
    rebuild 1
    sha256 "22622f0b6f9e38ad7a25f3cfbc0a5a746a4a349a15064564d9c0aa5da9fdf8a5" => :high_sierra
    sha256 "a8efbd8585b0b571057520d521b2c9751bd4985182e4178830ca0fbfd45e4b82" => :sierra
    sha256 "c0fa6f0ef6d0cfd4fb051cc941873671e94f4c005d0573d87f3f5c3cdbf456c5" => :el_capitan
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
