class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/0.21.2.tar.gz"
  sha256 "369d1c8d61ec9f8ea507acd0e104491979f60b27f74013362514d1796659347d"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "bda8cb07fb0498eaae3a1965ab8a726948cf67a6f16a56a53171694262987557" => :sierra
    sha256 "e84d8caf08557d1bd0af0479fde3089df5103d1b9154143731955fe1391b7936" => :el_capitan
    sha256 "0b6d36bab83634389bf9a4991d51529ab8195a112a696b5226319e3a53852a9e" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libffi"
  depends_on "openssl"

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    system bin/"conan", "install", "zlib/1.2.8@lasote/stable", "--build"
    assert_predicate testpath/".conan/data/zlib/1.2.8", :exist?
  end
end
