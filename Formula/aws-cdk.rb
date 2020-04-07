require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.32.0.tgz"
  sha256 "e72f3ee4eb6cbc98c15ffdef9438174e60c7415886b78b3c6cf04b186aa76fdc"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b15f71337865bd1dd29e38e679033c9e5100de13d63c512b46aff7e4ababbfd" => :catalina
    sha256 "0cfd41752882f8b57d846211867dc872b35a8fee3e6eb8f980ced5d03eefe13d" => :mojave
    sha256 "654520f3d4763718cb9ae28afdf1cc0d0c114fc088f6e197674011297cd75fd9" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    mkdir "testapp"
    cd testpath/"testapp"
    shell_output("#{bin}/cdk init app --language=javascript")
    list = shell_output("#{bin}/cdk list")
    cdkversion = shell_output("#{bin}/cdk --version")
    assert_match "TestappStack", list
    assert_match version.to_s, cdkversion
  end
end
