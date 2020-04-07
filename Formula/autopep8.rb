class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/ca/d3/bb1c5781415b2a4f7d48bcd4c62e735d5ebf40d4f8c325d654870bedb7a6/autopep8-1.5.1.tar.gz"
  sha256 "cc6be1dfd46f2c7fa00e84a357f1a269683985b09eaffb47654ed551194399eb"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a2a1f2ee6e7bff975b26f890421713874de2ade892ef2149445826d41fabd43" => :catalina
    sha256 "e1e9bf88db553ab96dfb61758ddc86ba88441d794828ec1d9417785cb960fa85" => :mojave
    sha256 "e9fbcc530cdd1117f7c804207ee61066099e7d142ef1ac90801e93d6fe69affc" => :high_sierra
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
    output = shell_output("echo \"x='homebrew'\" | #{bin}/autopep8 -")
    assert_equal "x = 'homebrew'", output.strip
  end
end
