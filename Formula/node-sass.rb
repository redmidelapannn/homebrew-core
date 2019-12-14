class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.23.7.tgz"
  sha256 "6113e3c3034a8d7701c9ecc73e7c2f53e6e419a47d42a63e26ac4546a878328e"

  bottle do
    cellar :any_skip_relocation
    sha256 "099ac2bdb2390826633d9d3c17c3e3866c63b55dcadb9be2e259652b0d3bb62d" => :catalina
    sha256 "df148f29132ff1a03451ebc097895dd5818a1b15b13d225b3be1e08ae46e5f48" => :mojave
    sha256 "2db7b0c35b18fa69aebbb87d3383262ed5956838d82c65761118ee0aceafb7ca" => :high_sierra
  end

  depends_on "node"

  # pull request at #47438
  # conflicts_with "dart-sass", :because => "both install a `sass` binary"

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

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end
