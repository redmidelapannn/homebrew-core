class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.9.2.tar.gz"
  sha256 "ee87763d8c21207d57df3406f6ce761a407f82a50e5fc5a8b3fa9202bce61ada"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "69b57790d0f436b63926d665f5d4bac81a9489f573949f5e9e303b59731e7a21" => :mojave
    sha256 "050fc3497f0ae9ac834b36f9e6a514e9f7234070aa9b125d839fea7c8d2796af" => :high_sierra
    sha256 "becd08ae973147940c11f5be61d06fbf325690be8c2883ad91361ef7b1017499" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl"
  depends_on "python"

  def install
    inreplace "conans/requirements.txt", "PyYAML>=3.11, <3.14.0", "PyYAML>=3.11"
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
