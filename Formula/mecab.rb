class Mecab < Formula
  desc "Yet another part-of-speech and morphological analyzer"
  homepage "https://taku910.github.io/mecab/"
  # Canonical url is https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE
  url "https://deb.debian.org/debian/pool/main/m/mecab/mecab_0.996.orig.tar.gz"
  sha256 "e073325783135b72e666145c781bb48fada583d5224fb2490fb6c1403ba69c59"

  bottle do
    rebuild 4
    sha256 "56cb5e6a9a442e8d809fd84b3ecf5fe9406008e78cd26eb1ca3f4737bf43bf9a" => :mojave
    sha256 "68c5173c7bd38df1e9bafcc8d91c17d52a8e3aca26e1223af39f760b9e9a9407" => :high_sierra
    sha256 "b60d0f7cc8e4d67122f31b09fd8091ca0b16d4119f3b7c1c1e41ea2840c8c8c2" => :sierra
  end

  conflicts_with "mecab-ko", :because => "both install mecab binaries"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"

    # Put dic files in HOMEBREW_PREFIX/lib instead of lib
    inreplace "#{bin}/mecab-config", "${exec_prefix}/lib/mecab/dic", "#{HOMEBREW_PREFIX}/lib/mecab/dic"
    inreplace "#{etc}/mecabrc", "#{lib}/mecab/dic", "#{HOMEBREW_PREFIX}/lib/mecab/dic"
  end

  def post_install
    (HOMEBREW_PREFIX/"lib/mecab/dic").mkpath
  end

  test do
    assert_equal "#{HOMEBREW_PREFIX}/lib/mecab/dic", shell_output("#{bin}/mecab-config --dicdir").chomp
  end
end
