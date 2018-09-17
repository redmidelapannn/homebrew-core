class Libspectrum < Formula
  desc "Support library for ZX Spectrum emulator"
  homepage "https://fuse-emulator.sourceforge.io/libspectrum.php"
  url "https://downloads.sourceforge.net/project/fuse-emulator/libspectrum/1.4.4/libspectrum-1.4.4.tar.gz"
  sha256 "fdfb2b2bad17bcfc98c098deaebf2a9811824b08d525172436d5eb134c9780b1"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ff5a3621628faf209aed235d2d187ed5d1ef7bcb45d360b334b4c44608b9b8eb" => :mojave
    sha256 "e3e210b043b6528c02890b5f5e856cd053f67015b27a347b16b0064994f617aa" => :high_sierra
    sha256 "c0ba35e833cae3753634b601896a36bf962538e0ddeac96cadc1f7f680ffcd49" => :sierra
    sha256 "da82f9d93303da9ea8e23778b9fbe30ef6ba43619c72fb2b4300e34f29cbd9bd" => :el_capitan
  end

  head do
    url "http://svn.code.sf.net/p/fuse-emulator/code/trunk/libspectrum"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
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
