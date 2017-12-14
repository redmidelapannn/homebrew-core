class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "https://github.com/westes/flex"
  url "https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz"
  sha256 "e87aae032bf07c26f85ac0ed3250998c37621d95f8bd748b31f15b33c45ee995"

  bottle do
    rebuild 1
    sha256 "e3801cac02d8ccfb78050c76beef8f65c673a19390efdea042c031c818d0f107" => :high_sierra
    sha256 "c56f17d9651581ee4702eff61eff566884c0ef187a79597844bd0b87bce117d4" => :sierra
    sha256 "226b5926c40408a26d3c15e110c611ca88d366f509548368c525ebbc2b29751b" => :el_capitan
  end

  head do
    url "https://github.com/westes/flex.git"

    # https://github.com/westes/flex/issues/294
    depends_on "gnu-sed" => :build

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_osx, "some formulae require a newer version of flex"

  depends_on "help2man" => :build
  depends_on "gettext"

  def install
    if build.head?
      ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"

      system "./autogen.sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-shared",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.flex").write <<~EOS
      CHAR   [a-z][A-Z]
      %%
      {CHAR}+      printf("%s", yytext);
      [ \\t\\n]+   printf("\\n");
      %%
      int main()
      {
        yyin = stdin;
        yylex();
      }
    EOS
    system "#{bin}/flex", "test.flex"
    system ENV.cc, "lex.yy.c", "-L#{lib}", "-lfl", "-o", "test"
    assert_equal shell_output("echo \"Hello World\" | ./test"), <<~EOS
      Hello
      World
    EOS
  end
end
