class Libtool < Formula
  desc "Generic library support script"
  homepage "https://www.gnu.org/software/libtool/"
  url "https://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.xz"
  mirror "https://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.xz"
  sha256 "7c87a8c2c8c0fc9cd5019e402bed4292462d00a718a7cd5f11218153bf28b26f"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "18005d9d4ed788c18cf738420710dd5a113748cd70650ab4c0d686ee0a8fc8c6" => :mojave
    sha256 "91d4560d39b53345fecaf0d014514436eed9489fa8d1c853763661b42c5d95ff" => :high_sierra
    sha256 "f8fcf2aefec4b87cda23190eb5fa68ca80fc96d0e2e1ea22bf189153a6c6390d" => :sierra
  end

  def install
    ENV["SED"] = "sed" # prevent libtool from hardcoding sed path from superenv
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--program-prefix=g",
                          "--enable-ltdl-install"
    system "make", "install"
  end

  def caveats; <<~EOS
    In order to prevent conflicts with Apple's own libtool we have prepended a "g"
    so, you have instead: glibtool and glibtoolize.
  EOS
  end

  test do
    system "#{bin}/glibtool", "execute", "/usr/bin/true"
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() { puts("Hello, world!"); return 0; }
    EOS
    system bin/"glibtool", "--mode=compile", "--tag=CC",
      ENV.cc, "-c", "hello.c", "-o", "hello.o"
    system bin/"glibtool", "--mode=link", "--tag=CC",
      ENV.cc, "hello.o", "-o", "hello"
    assert_match "Hello, world!", shell_output("./hello")
  end
end
