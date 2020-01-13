class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.21.0.tar.gz"
  sha256 "c820ed81dc07b7373b5a5a9537d85896435037fe9b35d43052f35ef05a69f411"
  revision 1
  head "https://github.com/conan-io/conan.git"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "18eb56535dfb9c6a850ffe26064ea687cd8a64b45691a7439530d5011b40e8bb" => :catalina
    sha256 "6401337199eaeef060f477dfacd61da3eedc4ba0621e4a4ebff4c9c8f8968d4a" => :mojave
    sha256 "44a0503b18bd644e803dd88dcaa5abe965d1f7d20549515f763a4ca313161f91" => :high_sierra
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
