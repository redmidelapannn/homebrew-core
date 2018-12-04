require "language/node"

class Bower < Formula
  desc "Package manager for the web"
  homepage "https://bower.io/"
  # Use Github tarball to avoid bowers npm 4+ incompatible bundled dep usage
  url "https://github.com/bower/bower/archive/v1.8.4.tar.gz"
  sha256 "62a6f019638e2a1628d2434a3c62cb62f8d88528fee9abaf6199d203e68cffbc"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "72feeda89ec5f1b5f755d4d7cc9c13e3f0b7c85f598dfa86de5f15a6e2ee5359" => :mojave
    sha256 "ed72d2a397e9b31847cf82229108e8294b244f84b7e5b4f13b9714c6a07e7fe1" => :high_sierra
    sha256 "83c6412a8a965c6631d03a95950ff67a38b992cd482d1b8556b45bd33c2f42fe" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"bower", "install", "jquery"
    assert_predicate testpath/"bower_components/jquery/dist/jquery.min.js", :exist?, "jquery.min.js was not installed"
  end
end
