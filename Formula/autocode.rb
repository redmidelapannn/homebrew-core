require "language/node"

class Autocode < Formula
  desc "Code automation for every language, library and framework"
  homepage "https://autocode.readme.io/"
  url "https://registry.npmjs.org/autocode/-/autocode-1.3.1.tgz"
  sha256 "952364766e645d4ddae30f9d6cc106fdb74d05afc4028066f75eeeb17c4b0247"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "f90052146464716445c56dbcce2837e972630498512dc8a883fd6f560e0c09eb" => :sierra
    sha256 "46a47469bb4aad951b79aa5aab512affa3dd3b7cfc7dd4da30308628d12505b3" => :el_capitan
    sha256 "4b4cf27c798c544ae0438a9f67672afe827639f7d289bbd109834f8beeb6467d" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".autocode/config.yml").write <<-EOS.undent
      name: test
      version: 0.1.0
      description: test description
      author:
        name: Test User
        email: test@example.com
        url: https://example.com
      copyright: 2015 Test
    EOS
    system bin/"autocode", "build"
  end
end
