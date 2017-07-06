require "language/node"

class Coffeescript < Formula
  desc "Unfancy JavaScript"
  homepage "http://coffeescript.org"
  url "https://registry.npmjs.org/coffeescript/-/coffeescript-1.12.6.tgz"
  sha256 "9d238f34cd8130c0011d305d94316844d39bbf9472dfe550b7596105b8de3b6f"
  head "https://github.com/jashkenas/coffeescript.git", :branch => "2"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "30cac3ee4e88fe70056f72e9f201b2f5fcb707453b7ae4ec0ddbe1caa7619075" => :sierra
    sha256 "e5775d9c2b371476a03ebc845d67da468b9f758956fd19a3b63d26c75602022e" => :el_capitan
    sha256 "98603fc486adf92f8a7fc464f99989938a5fcfd72680ac576e1e08a2968d0f0b" => :yosemite
  end

  devel do
    url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.0.0-beta3.tgz"
    sha256 "b4b63767f750a4ec16a3be87b1fd8c1006a4b7f65bbc5dcc16b523f177e1cd3b"
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
