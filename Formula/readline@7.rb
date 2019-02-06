class ReadlineAT7 < Formula
  desc "Library for command-line editing"
  homepage "https://tiswww.case.edu/php/chet/readline/rltop.html"
  url "https://ftp.gnu.org/gnu/readline/readline-7.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/readline/readline-7.0.tar.gz"
  version "7.0.5"
  sha256 "750d437185286f40a369e1e4f4764eda932b9459b5ec9a731628393dd3d32334"

  bottle do
    cellar :any
    sha256 "98c3583a98f0b4ca55d7ba2eb6b1eda59d1e9818c31fb5a4771d7c0af5967dcd" => :mojave
    sha256 "3c776a77c55b3f3488e9fe0fce6ffcfc40a45279e1a45f5ff8379b7b32d91ea6" => :high_sierra
    sha256 "1fe1243b8e274aa8c4002c610754e25a7654a7e553e8a6cab149ff79f4662093" => :sierra
  end

  keg_only :versioned_formula

  %w[
    001 9ac1b3ac2ec7b1bf0709af047f2d7d2a34ccde353684e57c6b47ebca77d7a376
    002 8747c92c35d5db32eae99af66f17b384abaca961653e185677f9c9a571ed2d58
    003 9e43aa93378c7e9f7001d8174b1beb948deefa6799b6f581673f465b7d9d4780
    004 f925683429f20973c552bff6702c74c58c2a38ff6e5cf305a8e847119c5a6b64
    005 ca159c83706541c6bbe39129a33d63bbd76ac594303f67e4d35678711c51b753
  ].each_slice(2) do |p, checksum|
    patch :p0 do
      url "https://ftp.gnu.org/gnu/readline/readline-7.0-patches/readline70-#{p}"
      mirror "https://ftpmirror.gnu.org/readline/readline-7.0-patches/readline70-#{p}"
      sha256 checksum
    end
  end

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
