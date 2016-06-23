class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  url "https://ftpmirror.gnu.org/bison/bison-3.0.4.tar.gz"
  mirror "https://ftp.gnu.org/gnu/bison/bison-3.0.4.tar.gz"
  sha256 "b67fd2daae7a64b5ba862c66c07c1addb9e6b1b05c5f2049392cfd8a2172952e"

  bottle do
    revision 1
    sha256 "451d6b14ede618e9c7ff0890fadf6498a9c9d6ece1db69a76432d7d693898ea0" => :el_capitan
    sha256 "48b559109883fc39e365db4561f1e28bd5ec764abd3739c17ae3bcc96551daab" => :yosemite
    sha256 "abc34d0b1617b7699d4d6c83dc76996b108fd93c53d10f1cf3cde4b76a03ff8c" => :mavericks
  end

  keg_only :provided_by_osx, "Some formulae require a newer version of bison."

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.y").write <<-EOS.undent
      %{ #include <iostream>
         using namespace std;
         extern void yyerror (char *s);
         extern int yylex ();
      %}
      %start prog
      %%
      prog:  //  empty
          |  prog expr '\\n' { cout << "pass"; exit(0); }
          ;
      expr: '(' ')'
          | '(' expr ')'
          |  expr expr
          ;
      %%
      char c;
      void yyerror (char *s) { cout << "fail"; exit(0); }
      int yylex () { cin.get(c); return c; }
      int main() { yyparse(); }
    EOS
    system "#{bin}/bison", "test.y"
    system ENV.cxx, "test.tab.c", "-o", "test"
    assert_equal "pass", shell_output("echo \"((()(())))()\" | ./test")
    assert_equal "fail", shell_output("echo \"())\" | ./test")
  end
end
