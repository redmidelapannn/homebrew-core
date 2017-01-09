class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "http://libtiff.maptools.org/"
  url "http://download.osgeo.org/libtiff/tiff-4.0.7.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/t/tiff/tiff_4.0.7.orig.tar.gz"
  sha256 "9f43a2cfb9589e5cecaa66e16bf87f814c945f22df7ba600d63aac4632c4f019"
  revision 1

  bottle do
    cellar :any
    sha256 "d5c6ed557885da6a7916e9f12b7525f1b98a8f5af8ab0835b0997bcc44669eb1" => :sierra
    sha256 "0300c8ab24c262720311fdf88d8d33e5d3c60bff6745b747d27f0ce8653b81d8" => :el_capitan
    sha256 "b07c7cc511ffd7d64287a5d55f63397863d4295843f4862ba3d84216548f02f3" => :yosemite
  end

  option :universal
  option :cxx11
  option "with-xz", "Include support for LZMA compression"

  depends_on "jpeg"
  depends_on "xz" => :optional

  # Patches from Debian for CVE-2016-10094, and various other issues.
  # All reported upstream, so should be safe to remove this block on next stable.
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/t/tiff/tiff_4.0.7-4.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/t/tiff/tiff_4.0.7-4.debian.tar.xz"
    sha256 "74c9c85b43e1bb1016f96665090da7d8481a48f66a53a43100ab78f729cef0c0"
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
          "patches/16-CVE-2016-10094.patch"
  end

  def install
    ENV.universal_binary if build.universal?
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
