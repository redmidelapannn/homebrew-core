class Cweb < Formula
  desc "Literate documentation system for C, C++, and Java"
  homepage "https://cs.stanford.edu/~knuth/cweb.html"
  # curl: (9) Server denied you to change to the given directory
  # ftp://ftp.cs.stanford.edu/pub/cweb/cweb-3.64b.tar.gz
  url "https://www.ctan.org/tex-archive/web/c_cpp/cweb/cweb-3.64b.tar.gz"
  sha256 "038b0bf4d8297f0a98051ca2b4664abbf9d72b0b67963a2c7700d2f11cd25595"

  bottle do
    rebuild 1
    sha256 "b41569d576cf888c93ab7aa34dd057c88866f3187218d5c365e32797d5188370" => :high_sierra
    sha256 "7e8ec973a8fc7419a6c7ce65d7b8dec694237fca4bc0b62455e3bbdd9867f57a" => :sierra
    sha256 "3286909bc3d5d996b5485b6f83c7669fbcf03fdd7b3f6b81497eac973f0d6b4b" => :el_capitan
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
