require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.43.0.tgz"
  sha256 "696a2a2ba38e64d1d5d33501e16a6f62982c8e4b7f06a8db8b7dbd76817292e9"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "59434ecbc1889e1a97d659cd0b4f3b54d83fc7a3a02738747db9de82123540d1" => :catalina
    sha256 "bb957132d335f0afefcff905ce7627ed26fdab4dfbdb1d0acc070c089f71ef9d" => :mojave
    sha256 "a574d4ac5caf444ee3f103f64fe5a2ea16b1ce238be6e88c86e6ac985ee2d9a1" => :high_sierra
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
