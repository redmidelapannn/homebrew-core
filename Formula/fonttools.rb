class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.7.0/fonttools-4.7.0.zip"
  sha256 "ce977f10f070752301e2d49ed822cfc860c881046d81c376fade1e6529b2046c"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f781081da9e8c9367041da6f1d979727b45335890bf2319f5d737c15185a33f6" => :catalina
    sha256 "7c5c3918aacaefa8b45d15062305f7e2b9b35a529be5ecb9a6c97e0e7e0922b4" => :mojave
    sha256 "9f6061bb209823345b5ae270620e94db38271f70204afd8782914fdc9793c504" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
    system bin/"ttx", "ZapfDingbats.ttf"
  end
end
