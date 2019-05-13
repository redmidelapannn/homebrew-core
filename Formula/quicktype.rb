require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-15.0.188.tgz"
  sha256 "a12e5d457bfb598307241b0dcf377a30d302085464ba46d4e17a07e4455183e3"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3c7dc30a7c56a96dcfb80a25ebcacdc5584eee6f28719cd8e822398529e6411" => :mojave
    sha256 "beb07ab6012dc4228111506c44f93c6b01f9ca7f3c287758ae456c495d873634" => :high_sierra
    sha256 "dc2a040f28bfd347628e1ab09cdb73cd5f6a474e7fa0b6b0c5415f5358c181cb" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"sample.json").write <<~EOS
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    EOS
    output = shell_output("#{bin}/quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end
