class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.25.0/fonttools-3.25.0.zip"
  sha256 "c1b7eb0469d4e684bb8995906c327109beac870a33900090d64f85d79d646360"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "49adcd20fc1a1d4e80dde628c4fc470681b2c0e0a0037f5b2243f9142b24d8ec" => :high_sierra
    sha256 "5fa7caee72dd512fb5daea9819bca35f095f90892c5691ed122ce7b53a927b41" => :sierra
    sha256 "b2a91e3ed2266de19ff1e42a82e80d15e688c49f953e858fa8dc5e14a04b4c43" => :el_capitan
  end

  option "with-pygtk", "Build with pygtk support for pyftinspect"

  depends_on "python@2"
  depends_on "pygtk" => :optional

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/Library/Fonts/Arial.ttf", testpath
    system bin/"ttx", "Arial.ttf"
  end
end
