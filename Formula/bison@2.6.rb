class BisonAT26 < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  url "https://ftp.gnu.org/gnu/bison/bison-2.6.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/bison/bison-2.6.4.tar.gz"
  sha256 "de2d15dfdcfc24405464cb95acc9d5ef31fb2e5be4aca6a530ec59bb57c30e5d"
  revision 1

  bottle do
    sha256 "28d633bd0070ee04ef7b1e6ed155fb93f3112076de1374907f597f7b61016aba" => :high_sierra
    sha256 "b47a9b7be35de020b287c36616e7c2ff99559d6b7ab650ae13bfe1bbc6044ece" => :sierra
    sha256 "4f8a7348082f2c7440404a21859bdafc98e1c15d9113e132a725d2f7463b5181" => :el_capitan
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/macports/macports-ports/b76d1e48dac/editors/nano/files/secure_snprintf.patch"
    sha256 "57f972940a10d448efbd3d5ba46e65979ae4eea93681a85e1d998060b356e0d2"
  end

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
