class FcitxRemoteForOsx < Formula
  desc "Handle input method in command-line"
  homepage "https://github.com/CodeFalling/fcitx-remote-for-osx"
  url "https://github.com/CodeFalling/fcitx-remote-for-osx/archive/0.3.0.tar.gz"
  sha256 "b4490a6a0db3c28ce3ddbe89dd038f5ab404744539adc5520eab1a1a39819de6"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ce627654b03abbf7f2a50729495484a8fec463d75e167d8981c1e3aa944ac7ba" => :mojave
    sha256 "7424d270d740c954836653997101510ec084d052696361d8f21b18bc24ec5ba2" => :high_sierra
    sha256 "95c79c36b2604ad78d129f8b18029267ec45254297eef877f68e3090ee9119e3" => :sierra
  end

  option "with-input-method=",
    "Select input method: general(default), baidu-pinyin, baidu-wubi, " \
    "sogou-pinyin, qq-wubi, squirrel-rime, squirrel-rime-upstream, osx-pinyin"

  def install
    input_method = ARGV.value("with-input-method") || "general"
    system "./build.py", "build", input_method
    bin.install "fcitx-remote-#{input_method}"
    bin.install_symlink "fcitx-remote-#{input_method}" => "fcitx-remote"
  end

  test do
    system "#{bin}/fcitx-remote", "-n"
  end
end
