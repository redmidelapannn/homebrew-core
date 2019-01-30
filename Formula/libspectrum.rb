class Libspectrum < Formula
  desc "Support library for ZX Spectrum emulator"
  homepage "https://fuse-emulator.sourceforge.io/libspectrum.php"
  url "https://downloads.sourceforge.net/project/fuse-emulator/libspectrum/1.4.4/libspectrum-1.4.4.tar.gz"
  sha256 "fdfb2b2bad17bcfc98c098deaebf2a9811824b08d525172436d5eb134c9780b1"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7b9e0b9017547ed2f7b320661297ab2a08d14015424e8994f77be1b74cc5f955" => :mojave
    sha256 "a670971b43e00d2b41eaa7ca3ac2c73e4a5df204cf070271774723556c4d4c5c" => :high_sierra
    sha256 "bf304f48b3250abcccfcc18481cb3900ac2462b6f19c28f3f17955e5a4b0c331" => :sierra
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
