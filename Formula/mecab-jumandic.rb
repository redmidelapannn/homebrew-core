class MecabJumandic < Formula
  desc "See mecab"
  homepage "https://taku910.github.io/mecab/"
  url "https://www.mirrorservice.org/sites/distfiles.macports.org/mecab/mecab-jumandic-7.0-20130310.tar.gz"
  mirror "https://mirrors.ustc.edu.cn/macports/distfiles/mecab/mecab-jumandic-7.0-20130310.tar.gz"
  sha256 "eaf216758edee9a159bc3d02507007318686b9537943268c4565cc1f9ef07f15"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0bf264927b2c60b37f231d4d84e5c2686935bdf865720f31cb27b527c9c69f32" => :sierra
    sha256 "0bf264927b2c60b37f231d4d84e5c2686935bdf865720f31cb27b527c9c69f32" => :el_capitan
    sha256 "0bf264927b2c60b37f231d4d84e5c2686935bdf865720f31cb27b527c9c69f32" => :yosemite
  end

  # Via ./configure --help, valid choices are utf8 (default), euc-jp, sjis
  option "with-charset=", "Select charset: utf8 (default), euc-jp, or sjis"

  deprecated_option "charset=" => "with-charset="

  depends_on "mecab"

  link_overwrite "lib/mecab/dic"

  def install
    charset = ARGV.value("with-charset") || "utf8"
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-charset=#{charset}
      --with-dicdir=#{lib}/mecab/dic/jumandic
    ]

    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
     To enable mecab-jumandic dictionary, add to #{HOMEBREW_PREFIX}/etc/mecabrc:
       dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/jumandic
    EOS
  end

  test do
    (testpath/"mecabrc").write <<-EOS.undent
      dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/jumandic
    EOS

    pipe_output("mecab --rcfile=#{testpath}/mecabrc", "すもももももももものうち\n", 0)
  end
end
