class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://github.com/sshuttle/sshuttle.git",
      :tag => "v0.78.4",
      :revision => "6ec42adbf4fc7ed28e5f3c0a813779e61fa01b0f"
  head "https://github.com/sshuttle/sshuttle.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1e3aa8ea29c01c830de075a3e678a04fe632c7c249a1a26ec1adb710dfbaaaaf" => :high_sierra
    sha256 "e2244343e61e6b4e236502ae7ce059eb25c726083fead7abb56b83143679d9ed" => :sierra
    sha256 "d175b8701719ca4b21bec43fad17fdcc192271577a3a4fcf6d8bbd66283a10ca" => :el_capitan
  end

  depends_on "python@2"

  def install
    # Building the docs requires installing
    # markdown & BeautifulSoup Python modules
    # so we don't.
    virtualenv_install_with_resources
  end

  test do
    system bin/"sshuttle", "-h"
  end
end
