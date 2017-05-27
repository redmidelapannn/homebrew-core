require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.0.6.tgz"
  sha256 "8e81804d726652448c954b8450225372ec49a8c4cce47186f1fba952e3a6c0ff"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "79f5c55d0aa17c3a92d5c65d1ba2ec8095b503555b82a5dddfe4f5f3bf02a201" => :sierra
    sha256 "cd5153ae458867affdc9b18282a7c7c75cec6b40525893068b7b228082359020" => :el_capitan
    sha256 "355a25426145233bc5a8eef54a53113894c7f0d1587fdacd977c29470d2dba74" => :yosemite
  end

  devel do
    url "https://registry.npmjs.org/@angular/cli/-/cli-1.1.0-rc.2.tgz"
    version "1.1.0-rc.2"
    sha256 "a025f4abd05665d88d1104a4854bde69921e2e49e8b327c60e52207e8fa64e7e"
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
