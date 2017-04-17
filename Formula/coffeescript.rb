require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "http://coffeescript.org"
  url "https://registry.npmjs.org/coffee-script/-/coffee-script-1.12.5.tgz"
  sha256 "caa67ae9689b58a7005760fb869d7b4e7c6b785e5f6934c3eee8673669a75394"
  head "https://github.com/jashkenas/coffeescript.git", :branch => "2"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c355498c1c7ea3b2307deb23905215943d53ae3a5d318697d1556f4721f918a5" => :sierra
    sha256 "54282cf94c54cce022a940f7f74531e8c09cc23aea7cc4995e3f807fe2bc714f" => :el_capitan
    sha256 "a182365d69d9c14aaa6f13f816acb7dee90ddb979c3c4475b9503d9220dd04fc" => :yosemite
  end

  devel do
    url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.0.0-beta1.tgz"
    sha256 "9976d3f9594209bcfbedfe290abcc3a8ec8767f698425cfd2bc1419a6e5589a7"
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
