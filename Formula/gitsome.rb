class Gitsome < Formula
  include Language::Python::Virtualenv

  desc "Supercharged Git/GitHub command-line interface (CLI)"
  homepage "https://github.com/donnemartin/gitsome"
  url "https://github.com/donnemartin/gitsome/archive/0.8.0.tar.gz"
  sha256 "6b0c9196d43c730b2d66ce39a78c25983661c2629ecc07f8bd50e92e25f8a841"

  bottle do
    cellar :any
    sha256 "6b4a32f6ea31fcb17dd2449732e254ee351e8977138b6d87c0abe19ce5ac4a55" => :catalina
    sha256 "277eac2008e970c80fa68c3ea34d9f6d6f04a9ad0c8f0b6650775221dc1daaa5" => :mojave
    sha256 "204d6d87ef2e7d712cfaf92d12c30b18c69ff307f6ef9c5151ef1f3dc9423fa6" => :high_sierra
  end

  depends_on "freetype"
  depends_on "jpeg"
  depends_on "python"

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/5b/bb/cdc8086db1f15d0664dd22a62c69613cdc00f1dd430b5b19df1bea83f2a3/Pillow-6.2.1.tar.gz"
    sha256 "bf4e972a88f8841d8fdc6db1a75e0f8d763e66e3754b03006cbc3854d89f1cb1"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", ".[all]"
    system libexec/"bin/pip", "uninstall", "-y", "gitsome"

    if MacOS.version >= :mojave
      sdk_path = MacOS::CLT.installed? ? "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk" : MacOS.sdk_path
    end

    resource("Pillow").stage do
      inreplace "setup.py" do |s|
        s.gsub! "openjpeg.h", "probably_not_a_header_called_this_eh.h"
        s.gsub! "ZLIB_ROOT = None", "ZLIB_ROOT = ('#{sdk_path}/usr/lib', '#{sdk_path}/usr/include')"
        s.gsub! "JPEG_ROOT = None", "JPEG_ROOT = ('#{Formula["jpeg"].opt_prefix}/lib', '#{Formula["jpeg"].opt_prefix}/include')"
        s.gsub! "FREETYPE_ROOT = None", "FREETYPE_ROOT = ('#{Formula["freetype"].opt_prefix}/lib', '#{Formula["freetype"].opt_prefix}/include')"
      end
      venv.pip_install Pathname.pwd
    end

    venv.pip_install_and_link buildpath
  end

  test do
    system "#{bin}/gitsome", "--version"
  end
end
