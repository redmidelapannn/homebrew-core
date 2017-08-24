class Libconfig < Formula
  desc "Configuration file processing library"
  homepage "https://www.hyperrealm.com/libconfig/"
  url "https://github.com/hyperrealm/libconfig/archive/v1.6.tar.gz"
  sha256 "18739792eb463d73525d7aea9b0a48b14106fae1cfec09aedc668d8c1079adf1"

  bottle do
    rebuild 1
    sha256 "a423e68bcc65d89d22401074f729f59b098b4906436eaeef272f627743c17c29" => :sierra
    sha256 "6da05c98d1a476ee9d7b2c7db8d6238383cb717c42ba4ae26efa1a130d8d10ce" => :el_capitan
    sha256 "0d770abb77338014f1986c56b7bf6b0f4f735b3a3d95992f8f2226f605c81fc7" => :yosemite
  end

  head do
    url "https://github.com/hyperrealm/libconfig.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"

    # Fixes "scanner.l:137:59: error: too few arguments to function call ..."
    # Forces regeneration of the BUILT_SOURCES "scanner.c" and "scanner.h"
    # Reported 6 Jun 2016: https://github.com/hyperrealm/libconfig/issues/66
    touch "lib/scanner.l"

    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <libconfig.h>
      int main() {
        config_t cfg;
        config_init(&cfg);
        config_destroy(&cfg);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lconfig",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
