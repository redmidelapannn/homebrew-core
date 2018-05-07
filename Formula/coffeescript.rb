require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "https://coffeescript.org/"
  url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.3.0.tgz"
  sha256 "695dffde7e71860020cfa0048f4f887b7f7066be194e27a821b3bedb3e7b2cc3"
  head "https://github.com/jashkenas/coffeescript.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6b469c00505da4537c845607fd028e884831e16a7a75db9d92263ffce0448e22" => :high_sierra
    sha256 "3125d2f9c3a646a7a462829e3f6c3f535736a57ca5ab024617c82c33296d9cf9" => :sierra
    sha256 "947f795d52554508bdc2e5481f3038aee80a45bb1a65ef67ac085cc9f3011a74" => :el_capitan
  end

  depends_on "node"

  conflicts_with "cake", :because => "both install `cake` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.coffee").write <<~EOS
      square = (x) -> x * x
      list = [1, 2, 3, 4, 5]

      math =
        root:   Math.sqrt
        square: square
        cube:   (x) -> x * square x

      cubes = (math.cube num for num in list)
    EOS

    system bin/"coffee", "--compile", "test.coffee"
    assert_predicate testpath/"test.js", :exist?, "test.js was not generated"
  end
end
