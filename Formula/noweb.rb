class Noweb < Formula
  desc "WEB-like literate-programming tool"
  homepage "https://www.cs.tufts.edu/~nr/noweb/"
  # new canonical url (for newer versions): http://mirrors.ctan.org/web/noweb.zip
  url "https://deb.debian.org/debian/pool/main/n/noweb/noweb_2.11b.orig.tar.gz"
  sha256 "c913f26c1edb37e331c747619835b4cade000b54e459bb08f4d38899ab690d82"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "defbd411e94a07418e7790ca92f4c1d4ebc7f4c0d5152233eeb600372e35eea2" => :mojave
    sha256 "871529e7b98f93e21c1973257e49a4d789b53890ca867a16de71164dc8286fda" => :high_sierra
    sha256 "46ff0de4534617ba6e061d36e022f4cbed9fd9919445e7c9f15fec132249396f" => :sierra
  end

  depends_on "icon"

  def texpath
    prefix/"tex/generic/noweb"
  end

  def install
    cd "src" do
      system "bash", "awkname", "awk"
      system "make LIBSRC=icon ICONC=icont CFLAGS='-U_POSIX_C_SOURCE -D_POSIX_C_SOURCE=1'"

      bin.mkpath
      lib.mkpath
      man.mkpath
      texpath.mkpath

      system "make", "install", "BIN=#{bin}",
                                "LIB=#{lib}",
                                "MAN=#{man}",
                                "TEXINPUTS=#{texpath}"
      cd "icon" do
        system "make", "install", "BIN=#{bin}",
                                  "LIB=#{lib}",
                                  "MAN=#{man}",
                                  "TEXINPUTS=#{texpath}"
      end
    end
  end

  def caveats; <<~EOS
    TeX support files are installed in the directory:

      #{texpath}

    You may need to add the directory to TEXINPUTS to run noweb properly.
  EOS
  end

  test do
    (testpath/"test.nw").write <<~EOS
      \section{Hello world}

      Today I awoke and decided to write
      some code, so I started to write Hello World in \textsf C.

      <<hello.c>>=
      /*
        <<license>>
      */
      #include <stdio.h>

      int main(int argc, char *argv[]) {
        printf("Hello World!\n");
        return 0;
      }
      @
      \noindent \ldots then I did the same in PHP.

      <<hello.php>>=
      <?php
        /*
        <<license>>
        */
        echo "Hello world!\n";
      ?>
      @
      \section{License}
      Later the same day some lawyer reminded me about licenses.
      So, here it is:

      <<license>>=
      This work is placed in the public domain.
    EOS
    assert_match "this file was generated automatically by noweave",
                 shell_output("#{bin}/noweave -filter l2h -index -html test.nw | #{bin}/htmltoc")
  end
end
