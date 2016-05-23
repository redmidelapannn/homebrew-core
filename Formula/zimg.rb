class Zimg < Formula
  desc "Scaling, colorspace conversion, and dithering library"
  homepage "https://github.com/sekrit-twc/zimg"
  url "https://github.com/sekrit-twc/zimg/archive/release-2.1.tar.gz"
  sha256 "09093bbb4d73865362e1e346762a6efdc9acc3d2cab6a2ebf5f00ba5d90b17c3"

  bottle do
    cellar :any
    revision 1
    sha256 "f38d4b545de5ed8eba12d1298c9a35e50d907f7d629944a9136e371adf396288" => :el_capitan
    sha256 "c6e91161c902bf19f87fee4e3ba39efc86be004697fabec69f8221afb0f06bef" => :yosemite
    sha256 "376e00d66edd3bb56c389eb8f8d99e12bb148da74c4056378be1374a8a001e76" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
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
