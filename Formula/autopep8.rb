class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://github.com/hhatto/autopep8/archive/v1.3.5.tar.gz"
  sha256 "45938f23d725f17f41477878aa423c7a8bcd5374df65f55d0a4b53a1da9477ae"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "eb07e630ad73966e217054a9a58d26ba8d958d3507c8851e146216ae878f8329" => :high_sierra
    sha256 "05ab5c994a9e71ee2e09af3c406c0211eb0ac452126bffb2bc2cfe87246123a9" => :sierra
    sha256 "2d1fa93fdfd6b1b5e889289c014a10803cd9fdb32386ac256976c7098aa2fb63" => :el_capitan
  end

  depends_on "python@2"

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    output = shell_output("echo \"x='homebrew'\" | #{bin}/autopep8 -")
    assert_equal "x = 'homebrew'", output.strip
  end
end
