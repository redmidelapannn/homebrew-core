class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.15.0/fonttools-3.15.0.zip"
  sha256 "0879a390dddef681c575fe187880a4c5d24dfeef547781c48691bf7c46c0c5a5"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f78addb16010cd14d10126b86c322987e59f268f923c7398286c82205cc5512" => :sierra
    sha256 "b0ef913b78c1cd4dada5536eb770af9fbf2d9f40412b0325e82efa0ae07f69c5" => :el_capitan
    sha256 "813d1ef3a5a57c415377b42ee72218540757908a184b554927dfec995e62d9c1" => :yosemite
  end

  option "with-pygtk", "Build with pygtk support for pyftinspect"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "pygtk" => :optional

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/Library/Fonts/Arial.ttf", testpath
    system bin/"ttx", "Arial.ttf"
  end
end
