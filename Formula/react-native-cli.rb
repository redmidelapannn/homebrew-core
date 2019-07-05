require "language/node"

class ReactNativeCli < Formula
  desc "The React Native CLI tools"
  homepage "https://facebook.github.io/react-native/"
  url "https://registry.npmjs.org/react-native-cli/-/react-native-cli-2.0.1.tgz"
  sha256 "f1039232c86c29fa0b0c85ad2bfe0ff455c3d3cd9af9d9ddb8e9c560231a8322"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f821c21f8bfbb3a49833c76aa395c25699c4221b213712952a1186906339445e" => :mojave
    sha256 "7e4ba0d35a7b13c4c3fbf8894fa59c79777f1bb9e3f976a18e881879cb6a51f5" => :high_sierra
    sha256 "79d38aafb0167345f89bfe60d95d506324b5f3b5170e76f9ab43cabd98b9701e" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/react-native init test --version=react-native@0.59.x")
    assert_match "Run instructions for Android", output
  end
end
