require "language/node"

class Yarn < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.18.1/yarn-v0.18.1.tar.gz"
  sha256 "7d16699c8690ef145e1732004266fb82a32b0c06210a43c624986d100537b5a8"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "38888a04d979d2444a2a710ae28c7d57fb04dede0ef334e0ba27f73d1810897f" => :sierra
    sha256 "bde1097c57739197d362f408b1099ad119f02f543e131d01709a0593859495c7" => :el_capitan
    sha256 "377281ce7b79bc78fe7c335d22733dbf6e9d446e8496f5150ecacf3db1aca1d0" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats; <<-EOS.undent
    Add path:
      export PATH="$PATH:`yarn global bin`"
    EOS
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"yarn", "add", "jquery"
  end
end
