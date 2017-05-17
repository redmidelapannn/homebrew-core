class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.12.0/fonttools-3.12.0.zip"
  sha256 "950c46c60d495f59e40c7928b3220fd26fb83edf608c8c2a2d03119fe4b6e2d7"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0356e2ea6b9f56bdf2b3311d5529d1d820c1e84a9804f220c9860be5e909ea17" => :sierra
    sha256 "4a7fa740ae454633bcaa969324ff3e63a985b851b2d8d74317449548cbd994ce" => :el_capitan
    sha256 "c5fea9492a2b2efae5e326361a854ac09e67dd8b628f899b14513504c1cf9dc4" => :yosemite
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
