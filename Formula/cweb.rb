class Cweb < Formula
  desc "Literate documentation system for C, C++, and Java"
  homepage "https://cs.stanford.edu/~knuth/cweb.html"
  url "https://www.ctan.org/tex-archive/web/c_cpp/cweb/cweb-3.64b.tar.gz"
  mirror "ftp://ftp.cs.stanford.edu/pub/cweb/cweb-3.64b.tar.gz"
  sha256 "038b0bf4d8297f0a98051ca2b4664abbf9d72b0b67963a2c7700d2f11cd25595"

  bottle do
    rebuild 1
    sha256 "cbf31503336a1ed1fb4a4d262aaab6c468e55df2286205a15d4ff1f6fe4e4251" => :high_sierra
    sha256 "eec3126b64e540dff048ec709c006338947dac275a3268621a7521203b3d48ea" => :sierra
    sha256 "f2ca9786db6dce10daeebc3a447d373b6922b5adad57cb4a77b5ce587eed53a6" => :el_capitan
  end

  def install
    ENV.deparallelize

    macrosdir = share/"texmf/tex/generic"
    cwebinputs = lib/"cweb"

    # make install doesn't use `mkdir -p` so this is needed
    [bin, man1, macrosdir, elisp, cwebinputs].each(&:mkpath)

    system "make", "install",
      "DESTDIR=#{bin}/",
      "MANDIR=#{man1}",
      "MANEXT=1",
      "MACROSDIR=#{macrosdir}",
      "EMACSDIR=#{elisp}",
      "CWEBINPUTS=#{cwebinputs}"
  end

  test do
    (testpath/"test.w").write <<~EOS
      @* Hello World
      This is a minimal program written in CWEB.

      @c
      #include <stdio.h>
      void main() {
          printf("Hello world!");
      }
    EOS
    system bin/"ctangle", "test.w"
    system ENV.cc, "test.c", "-o", "hello"
    assert_equal "Hello world!", pipe_output("./hello")
  end
end
