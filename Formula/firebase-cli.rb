require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-7.16.2.tgz"
  sha256 "40a33e737ce467c3a761f6a056fcf408db1632a6bbd503228ef2cf5470d1ed72"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "53adac3e8a6ae7c3a9d05ed8d9b6f8c635bd2d9292a873773a9c151daaf5be8e" => :catalina
    sha256 "d4a4e9c9dfaba813526c7bd04fb17fc6ad2f3d8e04a470beec697d72253ca2a1" => :mojave
    sha256 "45eb700caafa9f1f335ba0296acbd60003271b00cccf8cae2bad6cb61ffee3a3" => :high_sierra
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end
