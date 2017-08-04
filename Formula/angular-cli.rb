require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.2.7.tgz"
  sha256 "26a6c39d953aa8b99ef6aebbeae935d0582c296bfa04cf85722c598386d3a611"

  bottle do
    sha256 "e442b23383b736c398ef06d41931faa7359699fa36b9f4e7887242fbf1d3937c" => :sierra
    sha256 "1b148c04fad9483f856940aa8ed4efe74b93470e4276c7b6191fe37ddecbccd2" => :el_capitan
    sha256 "82336b6afa4a90bddbb44b5bb336af9e65d2ad90d5cd60d79093023e687fee45" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "--skip-install", "angular-homebrew-test"
    assert File.exist?("angular-homebrew-test/package.json"), "Project was not created"
  end
end
