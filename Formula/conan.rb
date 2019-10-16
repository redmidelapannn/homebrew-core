class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.19.2.tar.gz"
  sha256 "1b824f14584a5da4deace6154ee49487faea99ddce3a2993f6a79f9a35b43d64"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "8a21d062c880c4bf25f76a0f8288dd68f44bbfa051a7bc22d88877334f40a687" => :catalina
    sha256 "43e044a96c7db8120a81c21017c4f277461b795ac78e70a4135f3d6432426e0f" => :mojave
    sha256 "f14cc8863080d741954b91c31087b0b6a53ec0920a05918f50a7baa7ca8e080d" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "python"

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
