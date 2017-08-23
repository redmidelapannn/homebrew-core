class Libunistring < Formula
  desc "C string library for manipulating Unicode strings"
  homepage "https://www.gnu.org/software/libunistring/"
  url "https://ftp.gnu.org/gnu/libunistring/libunistring-0.9.7.tar.xz"
  mirror "https://ftpmirror.gnu.org/libunistring/libunistring-0.9.7.tar.xz"
  sha256 "2e3764512aaf2ce598af5a38818c0ea23dedf1ff5460070d1b6cee5c3336e797"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5ceacc53e981ee2572b6c0e569b94076db1a4397f199bb6255cee0d4db3b0e4a" => :sierra
    sha256 "db9c34a01a49a2a84f6bb2ed90b50272f3fd2728997bfe41f01bf7d79e67dafc" => :el_capitan
    sha256 "0c09ce3bf7341a0a2c4f20df7b9d4ee0891726e828d22efe3ac7ff3ce09affff" => :yosemite
  end

  # Fix crash from usage of %n in dynamic format strings on High Sierra
  # Repurposed patch, credit to Jeremy Huddleston Sequoia <jeremyhu@apple.com>
  if MacOS.version >= :high_sierra
    patch :p0 do
      url "https://raw.githubusercontent.com/macports/macports-ports/edf0ee1e2cf/devel/m4/files/secure_snprintf.patch"
      sha256 "57f972940a10d448efbd3d5ba46e65979ae4eea93681a85e1d998060b356e0d2"
    end
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <uniname.h>
      #include <unistdio.h>
      #include <stdio.h>
      #include <stdlib.h>
      int main (void) {
        uint32_t s[2] = {};
        uint8_t buff[12] = {};
        if (u32_uctomb (s, unicode_name_character ("BEER MUG"), sizeof s) != 1) abort();
        if (u8_sprintf (buff, "%llU", s) != 4) abort();
        printf ("%s\\n", buff);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lunistring",
                   "-o", "test"
    assert_equal "🍺", shell_output("./test").chomp
  end
end
