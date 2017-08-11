class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "http://re2c.org"
  url "https://github.com/skvadrik/re2c/releases/download/1.0/re2c-1.0.tar.gz"
  sha256 "fee4a9f244dcf5c8109a605163976087943560370153abda89677009b884855b"

  bottle do
    cellar :any_skip_relocation
    sha256 "e5ad15ba2f0a79e0c8bd84db39fed5c26f0571ea3a89d1b93df07bb869e5bf3b" => :sierra
    sha256 "0f6654d151846be9199ad2498f41d5a2ad7904ccca815645e477d99addb891e0" => :el_capitan
    sha256 "fbc094e5a5053ca3baa4281ff7c2576341dcef87759d275b208a2d4d7bb464e3" => :yosemite
  end

  # Upstream commit from 11 Aug 2017 "Fixed #193: 1.0 build failure on macOS:
  # error: calling a private constructor of class 're2c::Rule'"
  patch :p2 do
    url "https://github.com/skvadrik/re2c/commit/2aae99cd.patch?full_index=1"
    sha256 "87786c33864f0b71fb2be68da3dcef7c70924c6d59248911180b1c3b153459ef"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      unsigned int stou (const char * s)
      {
      #   define YYCTYPE char
          const YYCTYPE * YYCURSOR = s;
          unsigned int result = 0;

          for (;;)
          {
              /*!re2c
                  re2c:yyfill:enable = 0;

                  "\x00" { return result; }
                  [0-9]  { result = result * 10 + c; continue; }
              */
          }
      }
    EOS
    system bin/"re2c", "-is", testpath/"test.c"
  end
end
