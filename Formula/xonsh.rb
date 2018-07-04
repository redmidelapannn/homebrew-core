class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.6.8.tar.gz"
  sha256 "77d8b64ddc600549fd073a3ead20c41e049e61e26e7f3337322449f7c9b11b71"
  revision 1
  head "https://github.com/xonsh/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4c4843f7f6e2a68bc2b7817b853ea2511d15c148efb8e93472853cd9978cd1f9" => :high_sierra
    sha256 "752d68c87137189e3256144a306c62d326290ecf64049cedf173497af77860ec" => :sierra
    sha256 "926315d1452d49d6c868b2e0ae0ecc380e72e7624f09901719d8acdeb7de2d7b" => :el_capitan
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
