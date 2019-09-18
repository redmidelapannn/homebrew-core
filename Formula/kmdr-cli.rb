require "language/node"

class KmdrCli < Formula
  desc "CLI for explaining shell commands"
  homepage "https://kmdr.sh/"
  url "https://registry.npmjs.org/kmdr/-/kmdr-0.1.34.tgz"
  sha256 "233814fb6665470720468ef419ff17c7fddcc47182785f979149352adfae30cf"
  head "https://github.com/ediardo/kmdr-cli.git"
  bottle do
    cellar :any_skip_relocation
    sha256 "ce0e77dcdde84e976f7c0d202a1fa9c99d3e870f5ba853a185e42d639816f1b3" => :mojave
    sha256 "706b2a0ab39576a954614ed9f3fd6c880a79dee79abc56afcc2beaec3a6bf3ea" => :high_sierra
    sha256 "bce4e15fb78d9504d9fa2ffc074d92771027eb68006625c21ca659c7dbf9042b" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "true"
  end
end
