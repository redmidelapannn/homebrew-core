class Libspectrum < Formula
  desc "Support library for ZX Spectrum emulator"
  homepage "https://fuse-emulator.sourceforge.io/libspectrum.php"
  url "https://downloads.sourceforge.net/project/fuse-emulator/libspectrum/1.4.4/libspectrum-1.4.4.tar.gz"
  sha256 "fdfb2b2bad17bcfc98c098deaebf2a9811824b08d525172436d5eb134c9780b1"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a056d989f53efb0ca58ec5c027a867c9502afb3385113606f7ced99a82a076f4" => :mojave
    sha256 "96d96a1d6a9d819ce9b8e72d74a6aa747289c229e02d4f69670651a33bd9dea5" => :high_sierra
    sha256 "d89448b50439fc5e0e50339d87054fafcf22a87d05cf71cda5035b96792f88da" => :sierra
  end

  head do
    url "https://svn.code.sf.net/p/fuse-emulator/code/trunk/libspectrum"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "audiofile"
  depends_on "glib"
  depends_on "libgcrypt"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "libspectrum.h"
      #include <assert.h>

      int main() {
        assert(libspectrum_init() == LIBSPECTRUM_ERROR_NONE);
        assert(strcmp(libspectrum_version(), "#{version}") == 0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lspectrum", "-o", "test"
    system "./test"
  end
end
