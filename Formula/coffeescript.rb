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
    sha256 "17dc4a78d5499a20b776761be2bfceb93ef3045f4df98866eed83a9749d03030" => :sierra
    sha256 "903059581ee17f3bd0f2b95e3054338fe5df842608539a0d8162e740b68b43db" => :el_capitan
    sha256 "ff133ee1d7adaa3725ba189e3aee0fc12fb8ed14a74f80a1a7db6d2b18942fe6" => :yosemite
  end

  devel do
    url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.0.0-beta3.tgz"
    sha256 "b4b63767f750a4ec16a3be87b1fd8c1006a4b7f65bbc5dcc16b523f177e1cd3b"
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
