class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the SoulSeek peer-to-peer system."
  homepage "https://www.nicotine-plus.org/"
  url "https://github.com/Nicotine-Plus/nicotine-plus/archive/1.4.1.tar.gz"
  sha256 "1b38ef196d981e4eb96fa990cc463143289784f988f559c4400b1d461497b7d6"
  head "https://github.com/Nicotine-Plus/nicotine-plus.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d03fd00ebb599533fef85b8ea3e67c6849e56c4530601e658c2145025f49920e" => :sierra
    sha256 "a446739956560ef435c00da92c71877280208b01aba30886a9bfa19ad233acee" => :el_capitan
    sha256 "2d0f86da797287b949603b4b36fe0f9303af3088efdb6f2757f1299b687a20b3" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "gtk+"
  depends_on "pygtk"
  depends_on "geoip" => :recommended
  depends_on "miniupnpc" => :recommended

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/14/d5/51f49f345d4490a9a6a04677ab136f78e4e0c64ed142e48b4ed818c13c96/mutagen-1.37.tar.gz"
    sha256 "539553d3f1ffd890c74f64b819750aef0316933d162c09798c9e7eaf334ae760"
  end

  resource "python-geoip" do
    url "https://files.pythonhosted.org/packages/7c/65/cb04188154f7626e897d55f04c2542ba4205352f158cd925d314ad1998ef/python-geoip-1.2.tar.gz"
    sha256 "b7b11dab42bffba56943b3199e3441f41cea145244d215844ecb6de3d5fb2df5"
  end

  resource "miniupnpc" do
    url "https://files.pythonhosted.org/packages/55/90/e987e28ed29b571f315afea7d317b6bf4a551e37386b344190cffec60e72/miniupnpc-1.9.tar.gz"
    sha256 "498b35c5443e8de566f3a4de4bceae28fbf6e08ed59afb5ffd516d0bb718bca6"
  end

  def install
    venv = virtualenv_create(libexec)
    venv.pip_install "mutagen"
    venv.pip_install "miniupnpc" if build.with? "miniupnpc"
    venv.pip_install "python-geoip" if build.with? "geoip"
    venv.pip_install_and_link buildpath
  end

  test do
    system "#{bin}/nicotine", "--version"
    system "#{bin}/nicotine", "--help"
  end
end
