require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.44.0.tar.gz"
  sha256 "8ed674ff38e1b9237e417217af76f4a64b45612c4d805fd07fc057a92f11c3a5"

  bottle do
    cellar :any_skip_relocation
    sha256 "fab4e904d7e0a0a4950f2fa4da02860172ce38a38ab0181c32008264d8645beb" => :mojave
    sha256 "cc621bf2538e767342c8a0b4fdabe954ebe1aaa0272aada7731e0cad67d8e62b" => :high_sierra
    sha256 "dbc58a9289a20af765fd781319e832fff5ce4a2476494f12e0e121ad7e8ad2a4" => :sierra
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
    output = shell_output("#{bin}/serverless package")
    assert_match "Serverless: Packaging service...", output
  end
end
