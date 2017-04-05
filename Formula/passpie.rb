class Passpie < Formula
  include Language::Python::Virtualenv

  desc "Manage login credentials from the terminal"
  homepage "https://github.com/marcwebbie/passpie"
  url "https://files.pythonhosted.org/packages/7a/e5/f808549a4ae369ed1d97795e6039085d38ec4244aa953fac3cb870c66fbc/passpie-1.6.0.tar.gz"
  sha256 "8d4371b89d02469d7f2cc4e79480f6f1c80dde81da33d2968c9a212d704a2213"
  head "https://github.com/marcwebbie/passpie.git"

  bottle do
    cellar :any
    sha256 "4ef9b1a1887b16053c9737b0c448603069ee455839a87743cb9773ce836fba12" => :sierra
    sha256 "a17de27d00ef38eccaa517ac60f17ddb78fd4a8b008004540e78e49c306e8eb5" => :el_capitan
    sha256 "c835ae9ae88452fb7b6fa13e873b15f41aef881f00f18aad5d7d4db7f6d9902c" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on :gpg

  resource "click" do
    url "https://files.pythonhosted.org/packages/7a/00/c14926d8232b36b08218067bcd5853caefb4737cda3f0a47437151344792/click-6.6.tar.gz"
    sha256 "cc6a19da8ebff6e7074f731447ef7e112bd23adf3de5c597cf9989f2fd8defe9"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/75/5e/b84feba55e20f8da46ead76f14a3943c8cb722d40360702b2365b91dec00/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "rstr" do
    url "https://files.pythonhosted.org/packages/34/73/bf268029482255aa125f015baab1522a22ad201ea5e324038fb542bc3706/rstr-2.2.4.tar.gz"
    sha256 "64a086a7449a576de7f40327f8cd0a7752efbbb298e65dc68363ee7db0a1c8cf"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/db/40/6ffc855c365769c454591ac30a25e9ea0b3e8c952a1259141f5b9878bd3d/tabulate-0.7.5.tar.gz"
    sha256 "9071aacbd97a9a915096c1aaf0dc684ac2672904cd876db5904085d6dac9810e"
  end

  resource "tinydb" do
    url "https://files.pythonhosted.org/packages/6c/2e/0df79439cf5cb3c6acfc9fb87e12d9a0ff45d3c573558079b09c72b64ced/tinydb-3.2.1.zip"
    sha256 "7fc5bfc2439a0b379bd60638b517b52bcbf70220195b3f3245663cb8ad9dbcf0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"passpie", "--help"
  end
end
