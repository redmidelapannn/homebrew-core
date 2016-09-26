class Libass < Formula
  desc "Subtitle renderer for the ASS/SSA subtitle format"
  homepage "https://github.com/libass/libass"
  url "https://github.com/libass/libass/releases/download/0.13.3/libass-0.13.3.tar.gz"
  sha256 "86c8c45d14e4fd23b5aa45c72d9366c46b4e28087da306e04d52252e04a87d0a"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7ea4c360c6a9645631a64e3236eb00c62731855e36a489c0f280b83f0c3cabb9" => :sierra
    sha256 "2ab1091363ee624af3f8fe12a7abe2198420d77db31c03e6d45cbd953d36f9fd" => :el_capitan
    sha256 "98591114ed494a339361b05c90d9db195442a1b560eea2b2de03187450c8388d" => :yosemite
  end

  head do
    url "https://github.com/libass/libass.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-fontconfig", "Disable CoreText backend in favor of the more traditional fontconfig"

  depends_on "pkg-config" => :build
  depends_on "yasm" => :build

  depends_on "freetype"
  depends_on "fribidi"
  depends_on "harfbuzz" => :recommended
  depends_on "fontconfig" => :optional

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--disable-coretext" if build.with? "fontconfig"

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include "ass/ass.h"
      int main() {
        ASS_Library *library;
        ASS_Renderer *renderer;
        library = ass_library_init();
        if (library) {
          renderer = ass_renderer_init(library);
          if (renderer) {
            ass_renderer_done(renderer);
            ass_library_done(library);
            return 0;
          }
          else {
            ass_library_done(library);
            return 1;
          }
        }
        else {
          return 1;
        }
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lass", "-o", "test"
    shell_output("./test")
  end
end
