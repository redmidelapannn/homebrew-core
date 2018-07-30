class Cweb < Formula
  desc "Literate documentation system for C, C++, and Java"
  homepage "https://cs.stanford.edu/~knuth/cweb.html"
  url "https://cs.stanford.edu/pub/cweb/cweb-3.64b.tar.gz"
  mirror "https://www.ctan.org/tex-archive/web/c_cpp/cweb/cweb-3.64b.tar.gz"
  sha256 "038b0bf4d8297f0a98051ca2b4664abbf9d72b0b67963a2c7700d2f11cd25595"

  bottle do
    rebuild 1
    sha256 "c06fa53dea6c2a2861d6c5f96c95406019fad240d49b23603efbc6ef72841f16" => :high_sierra
    sha256 "3510d66bd11f4487da154612dab0c4f6ba637c65cf06fa6cb6a7b8ccedfc85e3" => :sierra
    sha256 "f9c6e78b139fac9442bdc5ece8805fdaa442109734adc0155acf1509d32c7b39" => :el_capitan
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
