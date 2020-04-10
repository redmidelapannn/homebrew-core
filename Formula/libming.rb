class Libming < Formula
  desc "C library for generating Macromedia Flash files"
  homepage "http://www.libming.org"
  url "https://github.com/libming/libming/archive/ming-0_4_8.tar.gz"
  sha256 "2a44cc8b7f6506adaa990027397b6e0f60ba0e3c1fe8c9514be5eb8e22b2375c"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "0caff6c8953e82d68ef47d329b6b7ef5b332358737c6963a96b1dad03538c37a" => :catalina
    sha256 "ada149bb795688f677aa5ce2ac3486a1b4b688408447d515f442c1650954c1f0" => :mojave
    sha256 "8293937e84fba29f415ccdd759f1a64f652638fd69bbc7bc2c1bcca9010f3e79" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "libpng"
  depends_on :macos # Due to Python 2

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "perl"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-perl",
                          "--enable-python"
    system "make", "DEBUG=", "install"
  end

  test do
    (testpath/"test.c").write <<~'EOS'
      #include <ming.h>
      int main() {
        Ming_setScale(40.0);
        printf("scale %f\n", Ming_getScale());
        return Ming_init() != 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lming", "-I#{include}"
    assert_match "scale 40.0", shell_output("./test")
  end
end
