require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.67.3.tar.gz"
  sha256 "29905355428e417cdfcfd1c4dc1d5bc36f5ff42f06b5ae95411fa42d21b473a4"

  bottle do
    cellar :any_skip_relocation
    sha256 "10c8395fa76a5ac4a6e3c64503bb35611e5174c12574f411976cbf0d2d511b05" => :catalina
    sha256 "fc56dc2e1aa453b3f83cda56dc4e566767c1243687fb22ecdfbf6d20cfdfa93e" => :mojave
    sha256 "2f93a9bc530f5520d3fcfa08c915d01f69c420a5df53368122305b6c3ea04d5b" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"serverless.yml").write <<~EOS
      service: homebrew-test
      provider:
        name: aws
        runtime: python3.6
        stage: dev
        region: eu-west-1
    EOS

    system("#{bin}/serverless config credentials --provider aws --key aa --secret xx")
    output = shell_output("#{bin}/serverless package")
    assert_match "Serverless: Packaging service...", output
  end
end
