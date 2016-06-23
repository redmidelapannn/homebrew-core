class Automake < Formula
  desc "Tool for generating GNU Standards-compliant Makefiles"
  homepage "https://www.gnu.org/software/automake/"
  url "https://ftpmirror.gnu.org/automake/automake-1.15.tar.xz"
  mirror "https://ftp.gnu.org/gnu/automake/automake-1.15.tar.xz"
  sha256 "9908c75aabd49d13661d6dcb1bc382252d22cc77bf733a2d55e87f2aa2db8636"

  bottle do
    cellar :any_skip_relocation
    revision 3
    sha256 "a1c9b71091281849867b406c89a4343246b3fd4fe8291553c62c4d2fa49ca25a" => :el_capitan
    sha256 "c9c54f7f430e6229d334a04acd921adfc1dafc10f41580a0ecb5bcfd97caccbe" => :yosemite
    sha256 "16fc23b2a440575ab442a9a3f9337e48d1d618174eb74a83484849f14d022191" => :mavericks
  end

  keg_only :provided_until_xcode43

  depends_on "autoconf" => :run

  def install
    ENV["PERL"] = "/usr/bin/perl"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

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
    system bin/"aclocal"
    system bin/"automake", "--add-missing", "--foreign"
    system "autoconf"
    system "./configure"
    system "make"
    system "./test"
  end
end
