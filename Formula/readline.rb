class Readline < Formula
  desc "Library for command-line editing"
  homepage "https://tiswww.case.edu/php/chet/readline/rltop.html"
  revision 1

  stable do
    url "https://ftp.gnu.org/gnu/readline/readline-7.0.tar.gz"
    mirror "https://ftpmirror.gnu.org/readline/readline-7.0.tar.gz"
    version "7.0.3"
    sha256 "750d437185286f40a369e1e4f4764eda932b9459b5ec9a731628393dd3d32334"

    %w[
      001 9ac1b3ac2ec7b1bf0709af047f2d7d2a34ccde353684e57c6b47ebca77d7a376
      002 8747c92c35d5db32eae99af66f17b384abaca961653e185677f9c9a571ed2d58
      003 9e43aa93378c7e9f7001d8174b1beb948deefa6799b6f581673f465b7d9d4780
    ].each_slice(2) do |p, checksum|
      patch :p0 do
        url "https://ftp.gnu.org/gnu/readline/readline-7.0-patches/readline70-#{p}"
        mirror "https://ftpmirror.gnu.org/readline/readline-7.0-patches/readline70-#{p}"
        sha256 checksum
      end
    end
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "448d48efd93d95d532d3dd5ae70bffd33365ffe32adbb1fccbf5b054286068b0" => :high_sierra
    sha256 "4ecbc0082a6a59a864d41a53200fd09f67ec685705f8b53d54cc1a175336d588" => :sierra
    sha256 "b86d2284f604c3f30fccb8f56e16fa8705577b83523b0f7762c5125b3d7473d5" => :el_capitan
  end

  devel do
    url "https://ftp.gnu.org/gnu/readline/readline-8.0-alpha.tar.gz"
    mirror "https://ftpmirror.gnu.org/readline/readline-8.0-alpha.tar.gz"
    sha256 "81d975b3687c6dea260baf1754009ef24c4b2b851f35e0bef4c06be7524cbfba"
  end

  keg_only :shadowed_by_macos, <<~EOS
    macOS provides the BSD libedit library, which shadows libreadline.
    In order to prevent conflicts when programs look for libreadline we are
    defaulting this GNU Readline installation to keg-only.
  EOS

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <readline/readline.h>

      int main()
      {
        printf("%s\\n", readline("test> "));
        return 0;
      }
    EOS
    system ENV.cc, "-L", lib, "test.c", "-L#{lib}", "-lreadline", "-o", "test"
    assert_equal "test> Hello, World!\nHello, World!",
      pipe_output("./test", "Hello, World!\n").strip
  end
end
