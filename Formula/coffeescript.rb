require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "http://coffeescript.org"
  url "https://registry.npmjs.org/coffee-script/-/coffee-script-1.12.4.tgz"
  sha256 "7c6065dc1c2250cd20238f8daefac4bb988e061f6df9eba371db91389d3de2c0"
  head "https://github.com/jashkenas/coffeescript.git", :branch => "2"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "30c8ec27a6d5f72289a43a7eddc8315cd4b14dd1818e274e43d159d453b88ca8" => :sierra
    sha256 "9a95834b4172f59000508708d6d17a1e2c1ea974e700117a49ab4ed8c9394883" => :el_capitan
    sha256 "a515600f9f8f3eb5203dfd8e4ae9c0433011a1d88636ed942877369ab5e4f370" => :yosemite
  end

  devel do
    url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.0.0-alpha1.tgz"
    sha256 "6de0bb53bf3c98fab8151af7c4e2bb5a258f276d7bee1d5374b7a038557c39df"
  end

  depends_on "node"

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
