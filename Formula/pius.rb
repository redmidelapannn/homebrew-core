class Pius < Formula
  include Language::Python::Virtualenv

  desc "PGP individual UID signer"
  homepage "https://www.phildev.net/pius/"
  url "https://github.com/jaymzh/pius/archive/v2.2.6.tar.gz"
  sha256 "88727d2377db6d57e9832c0d923d42edd835ba1b14f1e455f90b024eba291921"
  head "https://github.com/jaymzh/pius.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d30a097d0b647320fd7f268adbf503b1ef2a26c4cee766771ebb9f271a9de954" => :high_sierra
    sha256 "65c6e52a841c9792cea06c8481d52bca9e150d4b05e96ae62e9827d77e4c652b" => :sierra
    sha256 "9ba949f5bb7186dd1802e24a2aa3e66f937cb5bf56ecb5ab13585bcfebd873ef" => :el_capitan
  end

  depends_on "gnupg"
  depends_on "python@2"

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install
    # Replace hardcoded gpg path (WONTFIX)
    inreplace "libpius/constants.py", %r{/usr/bin/gpg2?}, "/usr/bin/env gpg"
    virtualenv_install_with_resources
  end

  def caveats; <<~EOS
    The path to gpg is hardcoded in pius as `/usr/bin/env gpg`.
    You can specify a different path by editing ~/.pius:
      gpg-path=/path/to/gpg
    EOS
  end

  test do
    system bin/"pius", "-T"
  end
end
