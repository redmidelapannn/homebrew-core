require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-9.1.1.tgz"
  sha256 "3365a8432295560a7924981bc06f732f152dd4dc1f1da1668b4c66bc1f6f4ad7"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e88350312327364d1ea3d71431d2920ca180f871a12a657661f7a2b8f17c110" => :catalina
    sha256 "33329cbc39cc4f00a41167542ca352147cf00833d562e51011d5a0233a2e8e48" => :mojave
    sha256 "ca603b1449e6b9ec9b1a59d8d61ca6bd2ad3f7259aab2d77ea4c467726fbfda6" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
