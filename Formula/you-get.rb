class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/releases/download/v0.4.1099/you-get-0.4.1099.tar.gz"
  sha256 "331e43185e309d13943de2aeafc2c19cbe2f2af67a46f920106bbd2d76873ffd"
  revision 1
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "25ac7124fa3402c1de105ea6db8340eb3eb49cd7ad3b21b514bcdc0202dba447" => :high_sierra
    sha256 "8704db6671a93f6177c5eeca2d8560f0e43812f10f2d9c6f3b71590d7f9b4564" => :sierra
    sha256 "0ef9b9904ed943d496fab5d6249e3fed94a5c73091543d11212a7ed1242e8b22" => :el_capitan
  end

  depends_on "python"

  depends_on "rtmpdump" => :optional

  def install
    virtualenv_install_with_resources
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system bin/"you-get", "--info", "https://youtu.be/he2a4xK8ctk"
  end
end
