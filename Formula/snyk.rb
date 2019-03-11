require "language/node"

class Snyk < Formula
  desc "Find & fix known vulnerabilities in open-source dependencies"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.136.1.tgz"
  sha256 "05a347ae082533f50e7132fc86370b244a910f6d430d5747d63423a3a451feaa"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc0bfd2d5abc5a2170c4600475c1a62244b45682bd74c3062e8e5accbee91cbe" => :mojave
    sha256 "8358d59ae0b3ae75922933aaf926d3d398802291b5624e0be625f4e9c6b4e48b" => :high_sierra
    sha256 "ed11b6b9533f0def70710c107704f07df944b38512b70d6875fbd26809cd5699" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Try running `snyk wizard` to define a Snyk protect policy", shell_output("#{bin}/snyk policy", 1)
  end
end
