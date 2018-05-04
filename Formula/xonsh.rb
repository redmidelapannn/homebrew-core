class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.6.3.tar.gz"
  sha256 "982d75983518f83037afe51ea5926f8ebde54c7874174035e40ff710a5c9b022"
  head "https://github.com/xonsh/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "27d8c76ace6e80bbe4dd4c901612a66c9e5e08010e64c33529b6b8104814bf2b" => :high_sierra
    sha256 "0c70540bd1677d150c65ce85884eca725c397b0ba69e5e01145da76a25f34e90" => :sierra
    sha256 "42d1b4d491fb322b6221c3f8b5bd23d76ffe7dd0fa32e079d2bdad0344912b6b" => :el_capitan
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
