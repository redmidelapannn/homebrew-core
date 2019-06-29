class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  url "https://ftp.gnu.org/gnu/bison/bison-3.4.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.4.1.tar.xz"
  sha256 "27159ac5ebf736dffd5636fd2cd625767c9e437de65baa63cb0de83570bd820d"

  bottle do
    rebuild 1
    sha256 "960c7207b679711de3e77be47e02f22fcfbc9efa66eb8657c4db9145a19512e6" => :mojave
    sha256 "39a028f6e33cd63a53c410b8e4c9861681c3aec64498c64afec9a12240003103" => :high_sierra
    sha256 "fcd59e7d735af41abf62117d515e8d6f304d69dcb44c8045f1eda01bd8d1e8de" => :sierra
  end

  uses_from_macos "m4"

  keg_only :provided_by_macos, "some formulae require a newer version of bison"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.y").write <<~EOS
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
