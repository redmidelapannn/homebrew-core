require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-15.0.200.tgz"
  sha256 "cc921e796121b2b5e5e1afa71e56585ecd1dc53e21f1de599ecb7381dd9e9265"
  head "https://github.com/quicktype/quicktype.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "45ab2f4ac250590664a7ff52df539f31807a178fbd88139c764ef4870e1b1e9a" => :catalina
    sha256 "e44015ed48cffda89431aba27067c6cb86ccfe38f020563942e8d00a44bcd587" => :mojave
    sha256 "c107e179a41a0235d9f1f6f939d6ec3bb173a2c58b935da8442af15d5a0395bb" => :high_sierra
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
