require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "http://coffeescript.org"
  url "https://registry.npmjs.org/coffeescript/-/coffeescript-1.12.7.tgz"
  sha256 "307640c6bf0d7ac51f6ba41fc329a88487d7d4be4cdadd33200ceaf4e6977992"
  head "https://github.com/jashkenas/coffeescript.git", :branch => "2"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "30472bffc1927968f43b87c722ff5d2497de1d7ea1000a811c62042c17a824d3" => :sierra
    sha256 "86b011a7724875e70e0ba4d2110419a2bdd679fc2c3d66cda8fc8de589651fa6" => :el_capitan
    sha256 "dcb8edc4ee5c138f30006ef9941de728a15fc52a7d9b3bbb4b6e7d6f1847b8fb" => :yosemite
  end

  devel do
    url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.0.0-beta4.tgz"
    sha256 "90171eecc9bba7d5b16e17752e903404edc94867cee58205bc0cf23a5fbeb2fe"
  end

  depends_on "node"

  conflicts_with "cake", :because => "both install `cake` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.coffee").write <<-EOS.undent
      square = (x) -> x * x
      list = [1, 2, 3, 4, 5]

      math =
        root:   Math.sqrt
        square: square
        cube:   (x) -> x * square x

      cubes = (math.cube num for num in list)
    EOS

    system bin/"coffee", "--compile", "test.coffee"
    assert File.exist?("test.js"), "test.js was not generated"
  end
end
