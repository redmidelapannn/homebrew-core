class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "http://libtiff.maptools.org/"
  url "http://download.osgeo.org/libtiff/tiff-4.0.7.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/t/tiff/tiff_4.0.7.orig.tar.gz"
  sha256 "9f43a2cfb9589e5cecaa66e16bf87f814c945f22df7ba600d63aac4632c4f019"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "59d48692bdfb4c9227bfc8aa7ea707730851940f5f87e1d17d2c2a15e85b585c" => :sierra
    sha256 "71f0ea8e8db76025e3437d6def8c0a72445db1c6479ead43026dabd70efffb0d" => :el_capitan
    sha256 "965365f08bd6d1bf35dec11d7f6d332eb5c46ecb11b27ae4f8efe954afacad4e" => :yosemite
  end

  option :cxx11
  option "with-xz", "Include support for LZMA compression"

  depends_on "jpeg"
  depends_on "xz" => :optional

  # Patches from Debian for CVE-2016-10094, and various other issues.
  # All reported upstream, so should be safe to remove this block on next stable.
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/t/tiff/tiff_4.0.7-5.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/t/tiff/tiff_4.0.7-5.debian.tar.xz"
    sha256 "f4183c48ed74b6c3c3a74ff1f10f0cf972d3dba0f840cf28b5a3f3846ceb2be6"
    apply "patches/01-CVE.patch",
          "patches/02-CVE.patch",
          "patches/03-CVE.patch",
          "patches/04-CVE.patch",
          "patches/05-CVE.patch",
          "patches/06-CVE.patch",
          "patches/07-CVE.patch",
          "patches/08-CVE.patch",
          "patches/09-CVE.patch",
          "patches/10-CVE.patch",
          "patches/11-CVE.patch",
          "patches/12-CVE.patch",
          "patches/13-CVE.patch",
          "patches/14-CVE.patch",
          "patches/15-TIFFFaxTabEnt_bugfix.patch",
          "patches/16-CVE-2016-10094.patch",
          "patches/17-CVE-2017-5225.patch"
  end

  def install
    ENV.cxx11 if build.cxx11?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-x
      --with-jpeg-include-dir=#{Formula["jpeg"].opt_include}
      --with-jpeg-lib-dir=#{Formula["jpeg"].opt_lib}
    ]
    if build.with? "xz"
      args << "--with-lzma-include-dir=#{Formula["xz"].opt_include}"
      args << "--with-lzma-lib-dir=#{Formula["xz"].opt_lib}"
    else
      args << "--disable-lzma"
    end
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
