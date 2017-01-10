require "language/node"
class Bit < Formula
  desc "Bit - Distributed Code Component Manager"
  homepage "www.bitsrc.io"
  url "http://assets.bitsrc.io/release/0.1.0/bit_0.1.0_brew.tar.gz"
  sha256 "1a90905120b0a54178c6be154fcc9210e23df5a3b0e1fe68c99771c2cf7bdad6"

  depends_on "node"

  def install
    system "npm", "install" ,"-g" ,*Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

end

