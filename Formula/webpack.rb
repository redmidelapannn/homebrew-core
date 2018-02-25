require "language/node"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.0.0.tgz"
  sha256 "e4fe3bd6f31a856aaf880b33268318d56cc709f984a539f3d453cad5244b0340"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "3bcca43cb300f20de86b67b5fa880c950e8518ea89c92677e0a9be7ceee789ce" => :sierra
    sha256 "67a741ebe5ddf7528769cd9c5a0b3977ff4b1cd3226b994c603a65502f9c2ec9" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"index.js").write <<~EOS
      function component () {
        var element = document.createElement('div');
        element.innerHTML = 'Hello' + ' ' + 'webpack';
        return element;
      }

      document.body.appendChild(component());
    EOS

    system bin/"webpack", "index.js", "bundle.js"
    assert_predicate testpath/"bundle.js", :exist?, "bundle.js was not generated"
  end
end
