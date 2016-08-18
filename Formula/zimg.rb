class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://github.com/sekrit-twc/zimg/archive/release-2.2.tar.gz"
  sha256 "573ef25858623d90158f829d1fa66d4ef429a005034cae7a9dc3e9d250b9abf7"

  bottle do
    cellar :any
    sha256 "b3b0f4d75bd9ae784a4a8d5a1a87d5777fadf617254a1f2df82d1a97d6dfd08d" => :el_capitan
    sha256 "cbacd819e26db7209d92c45648c9a4679ab9d768ee1701be193caf9ba0810019" => :yosemite
  end

  depends_on :macos => :yosemite
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gcc" if DevelopmentTools.clang_build_version < 703

  needs :cxx11

  fails_with :clang do
    build 602
    cause "incomplete C++11 support"
  end

  fails_with :clang do
    build 700
    cause "incomplete C++11 support"
  end

  def install
    ENV.cxx11

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <assert.h>
      #include <zimg.h>

      int main()
      {
        zimg_image_format format;
        zimg_image_format_default(&format, ZIMG_API_VERSION);
        assert(ZIMG_MATRIX_UNSPECIFIED == format.matrix_coefficients);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lzimg", "-o", "test"
    system "./test"
  end
end
