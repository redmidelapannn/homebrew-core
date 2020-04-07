require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-2.0.4.tgz"
  sha256 "26c23b6df6156c2f21f6763a59b34d1520ba257188b659f625b93c9853c7ecbe"
  head "https://github.com/prettier/prettier.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa7bbaa884a5b9440d9b1e884ed0bf7d96060627f16b1c6c902cc5f68b419f55" => :catalina
    sha256 "fbe2eff8b1abcdb6a9d35526cf66d2aa9036e007bdc167a4d0b73a4db533429c" => :mojave
    sha256 "2b1f7e8b136af4b0c1a4be834aa4778d442773ec426ec71a1e30ca1671d3674d" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write("const arr = [1,2];")
    output = shell_output("#{bin}/prettier test.js")
    assert_equal "const arr = [1, 2];", output.chomp
  end
end
