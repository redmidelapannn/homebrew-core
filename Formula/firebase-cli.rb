require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.0.0.tgz"
  sha256 "a44a2884e6210b50486146dfaed35fde75d09d14920fbaa63d27ae2707197a09"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3105c3fb716ddfe65bc91e9d2b6ccd24e427af585bf132931a39a0911b9c928" => :catalina
    sha256 "fb59c615932a9601be6a9993f8ea240c679947086d8011dec660d4fd1df6dabf" => :mojave
    sha256 "7c746af8edf89d2ada3ec880b16a920e4c1f1c3114874046eb54f48dfa1666c7" => :high_sierra
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
