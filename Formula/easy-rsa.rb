class EasyRsa < Formula
  desc "CLI utility to build and manage a PKI CA."
  homepage "https://github.com/OpenVPN/easy-rsa"
  url "https://github.com/OpenVPN/easy-rsa/archive/3.0.1.tar.gz"
  sha256 "a1fff75a27ea7da3f37fbfed715633f55b9ca25f5b14cac38e525c5c995e68ae"

  bottle do
    cellar :any_skip_relocation
    sha256 "32bc16aebf4e80ffa152d47727a4c23d8a07b76be1a127b7ed6aae0e6cf78c57" => :el_capitan
    sha256 "18d586bdcd299bbe7fbd384af6cc0692fad64ce83f430e268af606ca391dcb60" => :yosemite
    sha256 "48cf94a81d86fd68e35f7083165d78198651f4d99c20f8feb3a8724b586b34fe" => :mavericks
  end

  depends_on "openssl"

  def install
    # We don't use the installer from the package, as it doesn't organize things
    # well for brew install. It puts the binary in the prefix root, and defaults
    # to a pki path that will be overwritten on installation.
    inreplace "easyrsa3/easyrsa" do |s|
      s.gsub! /set_var EASYRSA		"\$PWD"/,
              "set_var EASYRSA		\"#{libexec}\""
      s.gsub! /set_var EASYRSA_PKI	.*/,
              "set_var EASYRSA_PKI	\"#{etc}/pki\""
      openssl_path = Formula["openssl"].opt_bin/"openssl"
      s.gsub! /set_var EASYRSA_OPENSSL	openssl/,
              "set_var EASYRSA_OPENSSL	\"#{openssl_path}\""
    end
    bin.install "easyrsa3/easyrsa"
    libexec.install "easyrsa3/openssl-1.0.cnf", "easyrsa3/x509-types"
  end

  test do
    # Create a stub PKI directory in the test sandbox.
    ENV["EASYRSA_PKI"] = testpath/"pki"
    system bin/"easyrsa", "--help"
    system bin/"easyrsa", "init-pki"
  end
end
