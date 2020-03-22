require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-2.0.1.tgz"
  sha256 "d2ab0fee912fdeedba26c2da2f07d0811e51f2c8ae3583172d3444fbc68fa427"
  head "https://github.com/prettier/prettier.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8a17230e97eb3482ad6c4f0bc685fe257b73845fbde536fe5f64dc40b99b028" => :catalina
    sha256 "f257521956d71a2d811049ab01b4819bec8803a83ecdea9ca0af8d02b10a33e1" => :mojave
    sha256 "bdee81579a0e4e007351332578ec3c90b95ed899604bd44a02376adef98dbf4c" => :high_sierra
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
