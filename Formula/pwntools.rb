class Pwntools < Formula
  include Language::Python::Virtualenv

  desc "CTF framework used by Gallopsled in every CTF"
  homepage "https://pwntools.com/"
  url "https://github.com/Gallopsled/pwntools/archive/3.10.0.tar.gz"
  sha256 "9544c4f987a123f25dd9c6e0ad2b3d8d4f4385da66d2cfc8052480c7c5d59a82"
  revision 1

  bottle do
    cellar :any
    sha256 "8bac0e75ead0a020e9d2c4d7f3c6ed2ee42ccf27be526409b6da5f031bad6be4" => :high_sierra
    sha256 "8196a37fef7ecb475afd4598faf2d1911860d7ccf44ba87fee013ae14533ecc9" => :sierra
    sha256 "d006db2c30cb606a995c8badeb3b81cc8aa7cf6fe91d8e690b0fc4b846edb484" => :el_capitan
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "openssl@1.1"
  depends_on "binutils" => :recommended

  conflicts_with "moreutils", :because => "Both install `errno` binaries"

  def install
    venv = virtualenv_create(libexec)
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
