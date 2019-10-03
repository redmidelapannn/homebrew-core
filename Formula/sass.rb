require "language/node"

class Sass < Formula
  desc "Pure JavaScript implementation of SASS"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.22.10.tgz"
  sha256 "ecea121912cc18b742ae62e7473be26ac3783d95ce1f304deecc80e65a676a3a"

  bottle do
    cellar :any_skip_relocation
    sha256 "c18680ef290f752b80b3373058f994231ca5342fdc53771a60f3b6d39931b4ca" => :catalina
    sha256 "ecddcb61579a0cae910a909bc2e8dcc6e8f4053ddf1b4c541ed6291ab1b2a7bb" => :mojave
    sha256 "dfed14e3d6fd058453eb56717c8c03f9ccc780f4d5da4aee0a418c7ce292fef9" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    output = shell_output("#{bin}/sass --style=compressed test.scss").strip
    assert_equal "div img{border:0px}", output
  end
end
