class Automake < Formula
  desc "Tool for generating GNU Standards-compliant Makefiles"
  homepage "https://www.gnu.org/software/automake/"
  url "https://ftp.gnu.org/gnu/automake/automake-1.16.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/automake/automake-1.16.2.tar.xz"
  sha256 "ccc459de3d710e066ab9e12d2f119bd164a08c9341ca24ba22c9adaa179eedd0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c4e7b22b42e77800733d9d12e1360cab6ff7ff0c8517ec114cee634b3b253157" => :catalina
    sha256 "c4e7b22b42e77800733d9d12e1360cab6ff7ff0c8517ec114cee634b3b253157" => :mojave
    sha256 "c4e7b22b42e77800733d9d12e1360cab6ff7ff0c8517ec114cee634b3b253157" => :high_sierra
  end

  depends_on "autoconf"

  def install
    ENV["PERL"] = "/usr/bin/perl"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    # Our aclocal must go first. See:
    # https://github.com/Homebrew/homebrew/issues/10618
    (share/"aclocal/dirlist").write <<~EOS
      #{HOMEBREW_PREFIX}/share/aclocal
      /usr/share/aclocal
    EOS
  end

  test do
    (testpath/"test.c").write <<~EOS
      int main() { return 0; }
    EOS
    (testpath/"configure.ac").write <<~EOS
      AC_INIT(test, 1.0)
      AM_INIT_AUTOMAKE
      AC_PROG_CC
      AC_CONFIG_FILES(Makefile)
      AC_OUTPUT
    EOS
    (testpath/"Makefile.am").write <<~EOS
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
