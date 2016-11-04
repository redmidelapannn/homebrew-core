class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "http://www.remotesensing.org/libtiff/"
  url "http://download.osgeo.org/libtiff/tiff-4.0.6.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/t/tiff/tiff_4.0.6.orig.tar.gz"
  sha256 "4d57a50907b510e3049a4bba0d7888930fdfc16ce49f1bf693e5b6247370d68c"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "7e5c7805c50b295f7ea28e5afd82ee6abbea67a585cae32b08cb883669492491" => :sierra
    sha256 "eaa5f2f6256f2dfa280caf0a3f14c7eaca3d12d1d988b104f302b4c495ed0847" => :el_capitan
    sha256 "03afeaa4a5dc440ab2fff3cdf56a17e47241a979530ce1fd7510355323029822" => :yosemite
  end

  option :universal
  option :cxx11
  option "with-xz", "Include support for LZMA compression"

  depends_on "jpeg"
  depends_on "xz" => :optional

  # Backports of various security/potential security fixes from Debian.
  # Already applied upstream in CVS but no new release yet.
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/t/tiff/tiff_4.0.6-3.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/t/tiff/tiff_4.0.6-3.debian.tar.xz"
    sha256 "cc650116c1dafed9c3721302f91e5e79b670f46712ebf2b86dea989c102e5c94"
    apply "patches/01-CVE-2015-8665_and_CVE-2015-8683.patch",
          "patches/02-fix_potential_out-of-bound_writes_in_decode_functions.patch",
          "patches/03-fix_potential_out-of-bound_write_in_NeXTDecode.patch",
          "patches/04-CVE-2016-5314_CVE-2016-5316_CVE-2016-5320_CVE-2016-5875.patch",
          "patches/05-CVE-2016-6223.patch",
          "patches/06-CVE-2016-5321.patch",
          "patches/07-CVE-2016-5323.patch",
          "patches/08-CVE-2016-3623_CVE-2016-3624.patch",
          "patches/09-CVE-2016-5652.patch",
          "patches/10-CVE-2016-3658.patch"
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
