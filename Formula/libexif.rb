class Libexif < Formula
  desc "EXIF parsing library"
  homepage "http://libexif.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/libexif/libexif/0.6.21/libexif-0.6.21.tar.gz"
  sha256 "edb7eb13664cf950a6edd132b75e99afe61c5effe2f16494e6d27bc404b287bf"

  bottle do
    cellar :any
    rebuild 2
    sha256 "5c9679d8e56e212b5244e5fee7966a87623d45492fcb89410ece2b60babaca58" => :sierra
    sha256 "2af0349b3ecdb2ed0a8584a5dd69dc55e62c1885055b8e05fa5677f93b634e62" => :el_capitan
    sha256 "bf23ec864e0a72529145cc96be25c5d92fdb6d1c4bea92620cb6d6434613dc04" => :yosemite
  end

  fails_with :llvm do
    build 2334
    cause "segfault with llvm"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <libexif/exif-loader.h>

      int main(int argc, char **argv) {
        ExifLoader *loader = exif_loader_new();
        ExifData *data;
        if (loader) {
          exif_loader_write_file(loader, argv[1]);
          data = exif_loader_get_data(loader);
          printf(data ? "Exif data loaded" : "No Exif data");
        }
      }
    EOS
    flags = %W[
      -I#{include}
      -L#{lib}
      -lexif
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    test_image = test_fixtures("test.jpg")
    assert_equal "No Exif data", shell_output("./test #{test_image}")
  end
end
