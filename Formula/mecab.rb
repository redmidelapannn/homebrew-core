class Mecab < Formula
  desc "Yet another part-of-speech and morphological analyzer"
  homepage "https://taku910.github.io/mecab/"
  # Canonical url is https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/mecab/mecab_0.996.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/m/mecab/mecab_0.996.orig.tar.gz"
  sha256 "e073325783135b72e666145c781bb48fada583d5224fb2490fb6c1403ba69c59"

  bottle do
    rebuild 4
    sha256 "ebb403681325d250f0f539357f17bc9aea93b33f771e09fe67a355f92b9d2ca9" => :high_sierra
    sha256 "e874d3cb4e449d70abefbb93e2cefafebe088e99661cb78804eb70f487d3778f" => :sierra
    sha256 "b05f6b73d7dea37a6e24b157075b543a3d62f3e99f076a8ce5d4004001d35916" => :el_capitan
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
