class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "http://www.hwaci.com/sw/lemon/"
  url "https://tx97.net/pub/distfiles/lemon-1.69.tar.bz2"
  sha256 "bc7c1cae233b6af48f4b436ee900843106a15bdb1dc810bc463d8c6aad0dd916"

  bottle do
    rebuild 1
    sha256 "2623364a85646296239c07a31d3745455080ae489e3fc728e82b11cc2be5ed02" => :sierra
    sha256 "3cecbaf130b4c197987fa24b2604a14210c35e5b6839e568c1200c84bdde4c71" => :el_capitan
    sha256 "d96adf30861f476e3e0bbbf4303ee72cb71f70cd39b18834c37e925c5cfffd08" => :yosemite
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
