class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://tx97.net/pub/distfiles/lemon-1.69.tar.bz2"
  sha256 "bc7c1cae233b6af48f4b436ee900843106a15bdb1dc810bc463d8c6aad0dd916"

  bottle do
    rebuild 1
    sha256 "4ebdbf3bf75a8ca3891ea0632f0d8b47a6f48aba0030400db1f95f66023ba25a" => :sierra
    sha256 "561d644be998b0498097422f4da6600b922dc92d807252c4de9fdacf6981b3dd" => :el_capitan
    sha256 "fa13f842ab1b5a8a7442f865497de6c73cd341bd1d1786042f1f943777d162fb" => :yosemite
  end

  def install
    pkgshare.install "lempar.c"

    # patch the parser generator to look for the 'lempar.c' template file where we've installed it
    inreplace "lemon.c", / = pathsearch\([^)]*\);/, " = \"#{pkgshare}/lempar.c\";"

    system ENV.cc, "-o", "lemon", "lemon.c"
    bin.install "lemon"
  end

  test do
    (testpath/"gram.y").write <<-EOS.undent
      %token_type {int}
      %left PLUS.
      %include {
        #include <iostream>
        #include "example1.h"
      }
      %syntax_error {
        std::cout << "Syntax error!" << std::endl;
      }
      program ::= expr(A).   { std::cout << "Result=" << A << std::endl; }
      expr(A) ::= expr(B) PLUS  expr(C).   { A = B + C; }
      expr(A) ::= INTEGER(B). { A = B; }
    EOS

    system "#{bin}/lemon", "gram.y"
    assert File.exist? "gram.c"
  end
end
