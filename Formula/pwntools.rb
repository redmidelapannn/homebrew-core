class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://github.com/Gallopsled/pwntools"
  url "https://github.com/Gallopsled/pwntools/archive/3.12.2.tar.gz"
  sha256 "8e048b514ee449b4c76f4eba1b4fcd48fdefd1bf04ae4c62b44e984923d2e979"
  revision 2

  bottle do
    cellar :any
    sha256 "ba89c608fa73dd12e1fe59a6ceb4a1d185894d44e45e9c1021d3e213b3cad204" => :catalina
    sha256 "38b7b0a68b20a827ff28b3a6d28e7eb66539a81542648d9ebcc2fabb35f66be0" => :mojave
    sha256 "8137d3336d645baa91918a8cbe4b827f8e6022ddf25fed83f25062306147adf6" => :high_sierra
  end

  depends_on "openssl@1.1"
  depends_on "python"

  conflicts_with "moreutils", :because => "Both install `errno` binaries"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    assert_equal "686f6d6562726577696e7374616c6c636f6d706c657465",
                 shell_output("#{bin}/hex homebrewinstallcomplete").strip
  end
end
