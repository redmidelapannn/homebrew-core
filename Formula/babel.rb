require "language/node"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/babel-cli/-/babel-cli-6.24.1.tgz"
  sha256 "d69a00bdb4f35184cda1f5bfe8075cd4d569600b8e61d864d1f08e360367933b"

  bottle do
    rebuild 1
    sha256 "95ebe21e8db79e0f79ecfb58772aa91ffa17817bd88934cc758dee3cb63d0686" => :sierra
    sha256 "bbea9524647b9f39f188beb82558539b7c65474f32d9f4c2a38ff4f75bef6611" => :el_capitan
    sha256 "ee256f3eccf6527370fa568cb5b42ae609d29ce80847c622ec0d1a7f386f2a9c" => :yosemite
  end

  devel do
    url "https://registry.npmjs.org/babel-cli/-/babel-cli-7.0.0-alpha.12.tgz"
    version "7.0.0-alpha.12"
    sha256 "a81e2421486ca48d3961c4ab1fada8acd3bb3583ccfb28822cbb0b16a2635144"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"script.js").write <<-EOS.undent
      [1,2,3].map(n => n + 1);
    EOS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert File.exist?("script-compiled.js"), "script-compiled.js was not generated"
  end
end
