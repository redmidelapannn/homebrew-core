class AutomakeAT112 < Formula
  desc "Tool for generating GNU Standards-compliant Makefiles"
  homepage "https://www.gnu.org/software/automake/"
  url "https://ftp.gnu.org/gnu/automake/automake-1.12.6.tar.gz"
  mirror "https://ftpmirror.gnu.org/automake/automake-1.12.6.tar.gz"
  sha256 "0cbe570db487908e70af7119da85ba04f7e28656b26f717df0265ae08defd9ef"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8fcbee3cf1eba9b45606a7f0b474c4e4a4f40b1eb6c253ca62675680f7bb2783" => :sierra
    sha256 "f5a04b71deeae2541c64589d642e741b847e6d5f5f741cd93524089c61bd669f" => :el_capitan
    sha256 "f5a04b71deeae2541c64589d642e741b847e6d5f5f741cd93524089c61bd669f" => :yosemite
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :run

  def install
    system "./configure", "--prefix=#{prefix}", "--program-suffix=112"
    system "make", "install"

    # Fix aclocal not escaping @ character correctly.
    inreplace "#{bin}/aclocal112",
      "\"#{share}/aclocal-$APIVERSION\"",
      "\"#{HOMEBREW_CELLAR}/automake\\@1.12/#{pkg_version}/share/aclocal-$APIVERSION\""

    # Our aclocal must go first. See:
    # https://github.com/Homebrew/homebrew/issues/10618
    (share/"aclocal/dirlist").write <<-EOS.undent
      #{HOMEBREW_PREFIX}/share/aclocal
      /usr/share/aclocal
    EOS
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      int main() { return 0; }
    EOS
    (testpath/"configure.ac").write <<-EOS.undent
      AC_INIT(test, 1.0)
      AM_INIT_AUTOMAKE
      AC_PROG_CC
      AC_CONFIG_FILES(Makefile)
      AC_OUTPUT
    EOS
    (testpath/"Makefile.am").write <<-EOS.undent
      bin_PROGRAMS = test
      test_SOURCES = test.c
    EOS
    system bin/"aclocal112"
    system bin/"automake112", "--add-missing", "--foreign"
    system "autoconf"
    system "./configure"
    system "make"
    system "./test"
  end
end
