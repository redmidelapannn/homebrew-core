class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "http://libtiff.maptools.org/"
  url "https://download.osgeo.org/libtiff/tiff-4.0.10.tar.gz"
  mirror "https://fossies.org/linux/misc/tiff-4.0.10.tar.gz"
  sha256 "2c52d11ccaf767457db0c46795d9c7d1a8d8f76f68b0b800a3dfe45786b996e4"

  bottle do
    cellar :any
    rebuild 1
    sha256 "78d1c1868ff2023f3b6ed454facf1937aa20664ab67c70d0bf908a3103b06379" => :mojave
    sha256 "077d20c808ef9c84d6aaf41d22d9f5cf06806b22216305142525318420a8e2f7" => :high_sierra
    sha256 "b03d8488b5311742666ddfad42803febf4fd441cf189a4324d65fdef169c524f" => :sierra
  end

  depends_on "jpeg"

  # Patches are taken from latest Fedora package, which is currently
  # libtiff-4.0.10-1.fc30.src.rpm and whose changelog is available at
  # https://apps.fedoraproject.org/packages/libtiff/changelog/

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-lzma
      --with-jpeg-include-dir=#{Formula["jpeg"].opt_include}
      --with-jpeg-lib-dir=#{Formula["jpeg"].opt_lib}
      --without-x
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <tiffio.h>

      int main(int argc, char* argv[])
      {
        TIFF *out = TIFFOpen(argv[1], "w");
        TIFFSetField(out, TIFFTAG_IMAGEWIDTH, (uint32) 10);
        TIFFClose(out);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ltiff", "-o", "test"
    system "./test", "test.tif"
    assert_match(/ImageWidth.*10/, shell_output("#{bin}/tiffdump test.tif"))
  end
end
