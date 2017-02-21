class MecabIpadic < Formula
  desc "IPA dictionary compiled for MeCab"
  homepage "https://taku910.github.io/mecab/"
  url "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM"
  version "2.7.0-20070801"
  sha256 "b62f527d881c504576baed9c6ef6561554658b175ce6ae0096a60307e49e3523"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "92f8e9b9106c1ebc79f1089198b26e4794757ba7b497e2b200695224c72f90d1" => :sierra
    sha256 "92f8e9b9106c1ebc79f1089198b26e4794757ba7b497e2b200695224c72f90d1" => :el_capitan
    sha256 "92f8e9b9106c1ebc79f1089198b26e4794757ba7b497e2b200695224c72f90d1" => :yosemite
  end

  # Via ./configure --help, valid choices are utf8 (default), euc-jp, sjis
  option "charset=", "Select charset: utf8 (default), euc-jp, or sjis"

  depends_on "mecab"

  link_overwrite "lib/mecab/dic"

  def install
    charset = ARGV.value("charset") || "utf8"
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-charset=#{charset}
      --with-dicdir=#{lib}/mecab/dic/ipadic
    ]

    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
     To enable mecab-ipadic dictionary, add to #{HOMEBREW_PREFIX}/etc/mecabrc:
       dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/ipadic
    EOS
  end

  test do
    (testpath/"mecabrc").write <<-EOS.undent
      dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/ipadic
    EOS

    pipe_output("mecab --rcfile=#{testpath}/mecabrc", "すもももももももものうち\n", 0)
  end
end
