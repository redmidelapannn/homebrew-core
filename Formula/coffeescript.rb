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
    sha256 "2e7ea8906191f920bad15a4117766ae4d497eb2b48d0fb8e31bf0b90e0e428d6" => :sierra
    sha256 "01556b46171511a3ee69be0bb7b217dc2d65baae3dc6e03eccfa1ff07b510395" => :el_capitan
    sha256 "3b238c40d0f00937a15806b637be9e2f75e9a57d7b71add77eae867554f8bbb0" => :yosemite
  end

  devel do
    url "https://registry.npmjs.org/coffeescript/-/coffeescript-2.0.0-beta2.tgz"
    sha256 "5ad1f1908b6fcaff08e3b6d052d7b90e590c65d930122e629e0ce1d37a8676d1"
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
