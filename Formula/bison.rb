class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  url "https://ftp.gnu.org/gnu/bison/bison-3.5.4.tar.xz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.5.4.tar.xz"
  sha256 "4c17e99881978fa32c05933c5262457fa5b2b611668454f8dc2a695cd6b3720c"

  bottle do
    sha256 "d3aa0a5c922f9a93c70f38480a1396c72430d4594f32f45bcd14d3ff1bcf18b1" => :catalina
    sha256 "dca31090fbd4d0aef15bffdac13d2ac2e8caeb71996453d83fc1be28e058f9b5" => :mojave
    sha256 "3df3866047c5ce7b647413ae476a24b46e9ac18cc952f94ca6df1c6df087704a" => :high_sierra
  end

  keg_only :provided_by_macos, "some formulae require a newer version of bison"

  uses_from_macos "m4"

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
