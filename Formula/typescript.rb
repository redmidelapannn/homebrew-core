require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-2.9.2.tgz"
  sha256 "70434cccfe6b627277175264b51405d8947b54dc23ae2e2c8040178f58a78062"
  head "https://github.com/Microsoft/TypeScript.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f752aad495ca588bcca1fcd2d1a7da98c921725dda74f59a65383cd1b2f9827d" => :high_sierra
    sha256 "fca2927df52566e90a5786f8c8d70da2ed21a9a9c92ae742d8a4079882779918" => :sierra
    sha256 "0a03a3222cce528d96f82a48c5ca5f11fbfd3187e23f717be26f91cefdbd48c5" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.ts").write <<~EOS
      class Test {
        greet() {
          return "Hello, world!";
        }
      };
      var test = new Test();
      document.body.innerHTML = test.greet();
    EOS

    system bin/"tsc", "test.ts"
    assert_predicate testpath/"test.js", :exist?, "test.js was not generated"
  end
end
