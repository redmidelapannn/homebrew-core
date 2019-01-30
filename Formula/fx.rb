require "language/node"

class Fx < Formula
  desc "Command-line JSON processing tool"
  homepage "https://github.com/antonmedv/fx"
  url "https://registry.npmjs.org/fx/-/fx-11.0.0.tgz"
  sha256 "9a76aa26525bf68eae81b1d9530daabd7a952f4d32fd0124fcdd30e2d6c3145f"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f281fdecbbe15b6d9b8af1729e87efbfa14d8d3f5c76f5afc8adf954db54aa7" => :mojave
    sha256 "a280028b28972dcc2bcc6126ab6cd78b476de1569386d3cec2e1ee4d57b590ad" => :high_sierra
    sha256 "6efe7bfd5387467fc6dcaac651d9f7ca11e498ae72415e4a9a90a1166840684c" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "bar", shell_output("echo '{\"foo\": \"bar\"}' #{bin}/fx .foo")
  end
end
