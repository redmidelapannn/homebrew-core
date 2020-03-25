require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.42.1.tgz"
  sha256 "ee6c7de29a42b5107526190688174bc0461941301db230d13de0591be2ea7100"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "b4147fdcfe402a2777c0ab2dbcf0a5ad4cac6c3b65951ea0841dde80a4f5a0a1" => :catalina
    sha256 "ebc2aab8e1829cbbf39d9f01ea42697b938526dd4335b9442baf44d7dd4dca54" => :mojave
    sha256 "2ea48f2ab6fbed2826a719c6a7639bb4c61564d9ec4688578c5c3fbbfca215a3" => :high_sierra
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-3.3.11.tgz"
    sha256 "dace2e99dc7b819b4695c69c327a0da9f56f799f15d20346b22a6cc22c5fb794"
  end

  def install
    (buildpath/"node_modules/webpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    # declare webpack as a bundledDependency of webpack-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["webpack"] = version
    pkg_json["bundledDependencies"] = ["webpack"]
    IO.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)

    bin.install_symlink libexec/"bin/webpack-cli"
    bin.install_symlink libexec/"bin/webpack-cli" => "webpack"
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

    system bin/"webpack", "index.js", "--output=bundle.js"
    assert_predicate testpath/"bundle.js", :exist?, "bundle.js was not generated"
  end
end
