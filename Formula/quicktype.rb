require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-12.0.10.tgz"
  sha256 "fcfc51effad2fe84c3ac96f02ca014bc69c132dbe237ba4b9a5e56e667642ce1"

  bottle do
    cellar :any_skip_relocation
    sha256 "879cbd48e684f654a85ca7ea81655212ac85421eb9b1fa051bb48c26c3e92ab9" => :high_sierra
    sha256 "c63a246cda300df17f13135d404e0bdc236b7e9dd50dcd57a66007ebfac8e12d" => :sierra
    sha256 "fb5d64c063fbbcbd91510adb5f2d18528759cde35bf1ca953025b61da51c4243" => :el_capitan
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
