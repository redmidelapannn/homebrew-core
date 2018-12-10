require "language/node"

class GenerateJsonSchema < Formula
  desc "Generate a JSON Schema from Sample JSON"
  homepage "https://github.com/Nijikokun/generate-schema"
  url "https://registry.npmjs.org/generate-schema/-/generate-schema-2.6.0.tgz"
  sha256 "1ddbf91aab2d649108308d1de7af782d9270a086919edb706f48d0216d51374a"
  head "https://github.com/Nijikokun/generate-schema.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "eb90f282ed56a12279fe5672c6a09533ac7221a5f4b0c3faee72d7030d03bdfd" => :mojave
    sha256 "187d97dba48b4ffbad6768387d33539bb26951e44228b1302d2862fceadfab70" => :high_sierra
    sha256 "c3bb01fcace1ab68c2d12e1c194c6495d492e2c0546d619d7d5faae6e98e1715" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.json").write <<~EOS
      {
          "id": 2,
          "name": "An ice sculpture",
          "price": 12.50,
          "tags": ["cold", "ice"],
          "dimensions": {
              "length": 7.0,
              "width": 12.0,
              "height": 9.5
          },
          "warehouseLocation": {
              "latitude": -78.75,
              "longitude": 20.4
          }
      }
    EOS
    assert_match "schema.org", shell_output("#{bin}/generate-schema test.json", 1)
  end
end
