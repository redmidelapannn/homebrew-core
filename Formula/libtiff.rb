class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "https://libtiff.gitlab.io/libtiff/"
  url "https://download.osgeo.org/libtiff/tiff-4.0.10.tar.gz"
  mirror "https://fossies.org/linux/misc/tiff-4.0.10.tar.gz"
  sha256 "2c52d11ccaf767457db0c46795d9c7d1a8d8f76f68b0b800a3dfe45786b996e4"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "a5b62ae7868b9072d28d4293ffe9717319a4af4703b7384d69a2490c4ae0a415" => :mojave
    sha256 "30e8331534228e49ede7be612a2ae6abb37dc9ac018ec6efda8fc1218fbec633" => :high_sierra
    sha256 "6b172f3245f20830cef5d0299f65a1c150024d46c264c71f165f8c74fa2a2332" => :sierra
  end

  depends_on "jpeg"

  # Patches are taken from latest Fedora package, which is currently
  # libtiff-4.0.10-2.fc30.src.rpm and whose changelog is available at
  # https://apps.fedoraproject.org/packages/libtiff/changelog/

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/d15e00544e7df009b5ad34f3b65351fc249092c0/libtiff/libtiff-CVE-2019-6128.patch"
    sha256 "dbec51f5bec722905288871e3d8aa3c41059a1ba322c1ac42ddc8d62646abc66"
  end

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
