require "language/node"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/cli/-/cli-7.0.0.tgz"
  sha256 "08dbc5415dc2de14994c96c5ae7190d4f4b01872629f6d8706d111d53b01c900"

  bottle do
    sha256 "6e13ed316467672c1ce9beb72d897635cd1800029e9798814bc1ef5e4083b428" => :high_sierra
    sha256 "966c888945304be3d627ceaec44cafae2b50e34d46add250d590b0879dd752f4" => :sierra
    sha256 "72cb613c172018449b3fb20b69366c97311b81f567a103104ae06ae07150694f" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"script.js").write <<~EOS
      [1,2,3].map(n => n + 1);
    EOS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert_predicate testpath/"script-compiled.js", :exist?, "script-compiled.js was not generated"
  end
end
