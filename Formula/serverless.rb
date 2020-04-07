require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.67.1.tar.gz"
  sha256 "f2f99c0ccc04bd3183bc6b05615a79eb5ae2eab5a686113d4e0b2481ba74dfb8"

  bottle do
    cellar :any_skip_relocation
    sha256 "39f5b355affd4de1a1fc7dd5e77d67eb8c56a8a5a13b7acb9ab4a4add0b3ee81" => :catalina
    sha256 "9f6ef3a806c19419d3dd4e5ca5b25631504caa3fe08748b31a4fbaad9dfd7f35" => :mojave
    sha256 "9a771d2eabe97624c48011374a28a7988b471d8f032ef997f375c557786cce15" => :high_sierra
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
