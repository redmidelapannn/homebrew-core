require "language/node"
class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://bitsrc.jfrog.io/bitsrc/bit-brew/stable/bit/0.6.4/bit-0.6.4-brew.tar.gz"
  sha256 "b1f8353381da7ff17ece2f99827d5c832336fbd7bb41ab0dd46a4b233eb4941a"

  bottle do
    cellar :any_skip_relocation
    sha256 "266cd15cbb2958deecb491e54e6f28636a7594540428966cdad70d2387b93a1d" => :sierra
    sha256 "8768d4363dd736a5ac0af62ac0d660b06a52e06a6a29f11762e55f9c45debf87" => :el_capitan
    sha256 "8768d4363dd736a5ac0af62ac0d660b06a52e06a6a29f11762e55f9c45debf87" => :yosemite
  end

  def install
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/bit"]
    bin.install_symlink Dir["#{libexec}/bin/bit.js"]
    bin.install_symlink "#{libexec}/bin/node" => "bitNode"
  end

  test do
    system bin/"bit", "init", "--skip-update"
  end
end
