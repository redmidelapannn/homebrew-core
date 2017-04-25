require "language/node"

class FirebaseCli < Formula
  desc "Firebase Command Line Tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-3.6.1.tgz"
  sha256 "0235f8752d8ab7db647c07a255cfbe0a3db62c75e770595170fb9126ce8456b8"
  head "https://github.com/firebase/firebase-tools.git"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # other commands require login to use
    system bin/"firebase", "--help"
  end
end
