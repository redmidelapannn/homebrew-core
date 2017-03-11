class Libspectrum < Formula
  desc "Support library for ZX Spectrum emulator"
  homepage "https://fuse-emulator.sourceforge.io/libspectrum.php"
  url "https://downloads.sourceforge.net/project/fuse-emulator/libspectrum/1.3.2/libspectrum-1.3.2.tar.gz"
  sha256 "c7d7580097116a7afd90f1e3d000e4b7a66b20178503f11e03b3a95180208c3f"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a98b43e9cfd84b4e7cae49a18bad1ef48b17b7d661af0e0a4536da62f2004625" => :sierra
    sha256 "a104bfdbd6580dc8a49f844e53699974880cdcd596c4aa2821297598965d10e3" => :el_capitan
    sha256 "eece8ee42bb74d5d7bedac3321bee2a6d23048bd832efacf7249db3115db07c5" => :yosemite
  end

  head do
    url "https://svn.code.sf.net/p/fuse-emulator/code/trunk/libspectrum"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libgcrypt" => :recommended
  depends_on "glib" => :recommended
  depends_on "audiofile" => :recommended

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
