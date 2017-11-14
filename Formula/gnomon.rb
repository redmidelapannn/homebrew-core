require "language/node"

class Gnomon < Formula
  desc "Utility to prepend timestamp information to another command's stdout"
  homepage "https://github.com/paypal/gnomon"
  url "https://github.com/paypal/gnomon/archive/v1.5.0.tar.gz"
  sha256 "5c9d83c33a1b364f0b2ad710416f97efd701b4f7a4bce800065a6b154772a695"
  head "https://github.com/paypal/gnomon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0b66a5ca004805b70da817e9b10f95ab989db52bcd397559919a5138ad8a55f" => :high_sierra
    sha256 "85b77a7837d85a334d9919d4c573481f89394a952c2d104a72e14668f2a03723" => :sierra
    sha256 "28b7865e5c6dcdf4667b50777880b4b27b0a8873576e99f3ba370a6cfdff35c4" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"gnomon", "version"
  end
end
