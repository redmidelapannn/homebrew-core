class Jbig2dec < Formula
  desc "JBIG2 decoder and library (for monochrome documents)"
  homepage "https://jbig2dec.com/"
  url "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs922/jbig2dec-0.14.tar.gz"
  sha256 "21b498c3ba566f283d02946f7e78e12abbad89f12fe4958974e50882c185014c"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b66bfe3d9038b94c648a3423185828e19d7bc68e88f85722572274f7467a7c34" => :mojave
    sha256 "77a357bfe8dc83cc5c7e5fae38b61672b2220e88b2f4c30dfce057adb9fe03dc" => :high_sierra
    sha256 "4d367d861e57542bd1b60e17f476d145be6ff30fbfdeff0e64147ab2c7ae2fea" => :sierra
    sha256 "29339bafdd899bfc155dd7c017bb13c0e1f1044e059923cfd9ecf5c93366fbdf" => :el_capitan
  end

  depends_on "libpng" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-silent-rules
    ]
    args << "--without-libpng" if build.without? "libpng"

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <stdlib.h>
      #include <jbig2.h>

      int main()
      {
        Jbig2Ctx *ctx;
        Jbig2Image *image;
        ctx = jbig2_ctx_new(NULL, 0, NULL, NULL, NULL);
        image = jbig2_image_new(ctx, 10, 10);
        jbig2_image_release(ctx, image);
        jbig2_ctx_free(ctx);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-DJBIG_NO_MEMENTO", "-L#{lib}", "-ljbig2dec", "-o", "test"
    system "./test"
  end
end
