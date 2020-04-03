class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/archive/v0.4.1432.tar.gz"
  sha256 "c35ebe75a2904f0dfcf75222109ee02e59aa45ade1105bdc15879cc1a0ae9264"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "8347ed90cf1caceb2cb6f9844dbd5c09fa00cf1f8d815886ed0013c0a6805301" => :catalina
    sha256 "eaf28dfae9e861745ad41275f6259f9393bdff2cc86c03401efce2ddef86c95d" => :mojave
    sha256 "11fdcaf61adc2cae2a24e7b544c050d5da1dd590c079e41f8510cbfeed90e925" => :high_sierra
  end

  depends_on "python@3.8"
  depends_on "rtmpdump"

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    "To use post-processing options, run `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system bin/"you-get", "--info", "https://youtu.be/he2a4xK8ctk"
  end
end
