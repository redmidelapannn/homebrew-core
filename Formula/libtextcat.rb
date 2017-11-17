class Libtextcat < Formula
  desc "N-gram-based text categorization library"
  homepage "https://software.wise-guys.nl/libtextcat/"
  url "http://pkgs.fedoraproject.org/repo/pkgs/libtextcat/libtextcat-2.2.tar.gz/128cfc86ed5953e57fe0f5ae98b62c2e/libtextcat-2.2.tar.gz"
  sha256 "5677badffc48a8d332e345ea4fe225e3577f53fc95deeec8306000b256829655"

  bottle do
    cellar :any
    rebuild 2
    sha256 "acf307eb174c015d6cbd31e815885aaead0bf4237f9c5c10e08b1bdc7af2a9bd" => :high_sierra
    sha256 "50aad2352d098f3273eafc9d594d9a4ea24c2756a93da7c5090bbf96a0749c74" => :sierra
    sha256 "1b8366dca6b3ba7c91ba4f92cfbb6ad7b4ed78b63b010e2f47898e53918c8079" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    (include/"libtextcat/").install Dir["src/*.h"]
    share.install "langclass/LM", "langclass/ShortTexts", "langclass/conf.txt"
  end

  test do
    system "#{bin}/createfp < #{prefix}/README"
  end
end
