class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.23.0.tar.gz"
  sha256 "0f670f1b7d14fb6edf106971651f311e447d3d6d09cdd3c59ff84fae4fcb79f7"
  revision 2
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "dedd483e0f68b4054e1876ebf7c567788d0ad338f73c9d259009152a842e2b2d" => :catalina
    sha256 "0f6ba33ab6394d922565a09d751ed976af8855e50807c28f65e519de16a44eb5" => :mojave
    sha256 "a49c414bf175229b81d7110c5626d6df28f2e027a3db3342fd36af638bec72b5" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "python@3.8"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", "PyYAML==3.13", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    system bin/"conan", "install", "zlib/1.2.11@conan/stable", "--build"
    assert_predicate testpath/".conan/data/zlib/1.2.11", :exist?
  end
end
