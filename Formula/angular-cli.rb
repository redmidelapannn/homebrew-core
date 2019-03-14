require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-7.3.6.tgz"
  sha256 "392276e02e4ac1dd10e3df45366f8661ea20683e0a668a7e3165beaf1478a60d"

  bottle do
    sha256 "3c2405798734fe33aaf127280b91ba53eb554c324c805f630ba71364899f3da9" => :mojave
    sha256 "cc492bea8f70cf6142796518f3059eed4bdbaffb2aa818673dd37dc3cec32cfb" => :sierra
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
