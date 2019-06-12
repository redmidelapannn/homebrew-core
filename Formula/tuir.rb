class Tuir < Formula
  include Language::Python::Virtualenv

  desc "Command-line Reddit client"
  homepage "https://gitlab.com/ajak/tuir"
  url "https://gitlab.com/ajak/tuir/-/archive/v1.28.1/tuir-v1.28.1.tar.gz"
  sha256 "a0ca434873a9f9258cd9b0868190bd4b64350b0eefb3eb90f185f984f02fd1cf"

  bottle do
    cellar :any_skip_relocation
    sha256 "52374297cd0ce7bfb1e8fb477b4eab85f8ea6e4f8ef412ca9adafc556208de5b" => :mojave
    sha256 "9e9033d8b6c118df8a21ea64077952db51a843516a58245b6a1738b6d50cfd09" => :high_sierra
    sha256 "0eea66f5bfe86181598e40e54c686793fd5693edb30297e6e9db7da7c92a306a" => :sierra
  end

  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
      "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    assert_equal "tuir 1.28.1\n", shell_output("#{bin}/tuir --version")
  end
end
