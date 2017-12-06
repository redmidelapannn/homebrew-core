require "language/node"

class Passcards < Formula
  desc "Language for application scale JavaScript development"
  homepage "http://robertknight.github.io/passcards/"
  url "https://registry.npmjs.org/passcards/-/passcards-0.7.1115.tgz"
  sha256 "b80f662146b0693655b20e155a72d8b24a3f62dc2e301ec2416403e9690fd2bb"
  head "https://github.com/robertknight/passcards.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "90c613ab0c01a35a20f3143de0f12edef18f437ea6207cd89bdb23b7d88729ff" => :high_sierra
    sha256 "2af6a606a1ed22b90a852274be6696bfc05dbdaf7769837559fcdbcb9fd9c962" => :sierra
    sha256 "51f2abe58dbd549dd7d4c1c97f2bbcf9ca842c1644d2e571cd27431fc9602733" => :el_capitan
  end

  depends_on "typescript"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"passcards", "-h"
  end
end
