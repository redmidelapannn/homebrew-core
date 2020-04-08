require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.0.2.tgz"
  sha256 "446c7ade85333293c9d6de7aee9f13ad3004065eb2d8c2e9ee7a32b03bf59f10"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "41ffdb1ca422e36abc83405bbcb840acad79c5f06e0d3931aaa1bdc964c093ba" => :catalina
    sha256 "c6d758dac58deefb3f1bd26e3e900f4b50d625ea4ff19e300b6aace5d8c757f1" => :mojave
    sha256 "8683322d084527f00a5b2df650e415533c918b5372cbd717306228b9006a5fb7" => :high_sierra
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
