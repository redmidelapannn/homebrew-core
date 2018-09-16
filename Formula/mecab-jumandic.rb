class MecabJumandic < Formula
  desc "See mecab"
  homepage "https://taku910.github.io/mecab/"
  url "https://www.mirrorservice.org/sites/distfiles.macports.org/mecab/mecab-jumandic-7.0-20130310.tar.gz"
  mirror "https://mirrors.ustc.edu.cn/macports/distfiles/mecab/mecab-jumandic-7.0-20130310.tar.gz"
  sha256 "eaf216758edee9a159bc3d02507007318686b9537943268c4565cc1f9ef07f15"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3f32642a83c72cc770c2f681b2e15fbf6129f80f49ed8a41a69eaffb16bb8e1c" => :mojave
    sha256 "3a8bc0c2108cb80e58cdf23be4a970748f81fccd7efc38e86af93b7562909b30" => :high_sierra
    sha256 "3a8bc0c2108cb80e58cdf23be4a970748f81fccd7efc38e86af93b7562909b30" => :sierra
    sha256 "3a8bc0c2108cb80e58cdf23be4a970748f81fccd7efc38e86af93b7562909b30" => :el_capitan
  end

  depends_on "mecab"

  link_overwrite "lib/mecab/dic"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-charset=utf8
      --with-dicdir=#{lib}/mecab/dic/jumandic
    ]

    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      To enable mecab-jumandic dictionary, add to #{HOMEBREW_PREFIX}/etc/mecabrc:
        dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/jumandic
    EOS
  end

  test do
    (testpath/"mecabrc").write <<~EOS
      dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/jumandic
    EOS

    pipe_output("mecab --rcfile=#{testpath}/mecabrc", "すもももももももものうち\n", 0)
  end
end
