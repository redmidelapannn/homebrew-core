require "language/node"

class Yarn < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.17.8/yarn-v0.17.8.tar.gz"
  sha256 "b54e762e2a54f1fb23c6b0f9c239c3791aae05aface5ea0d6498f2a7979b541c"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f9ef77b85cc2389f9ce1c3e86bbb65685e33bea376b5a19af2e8c5f69a6d4800" => :sierra
    sha256 "82c5df217e614ee6c873da154d0ce6e9d96f4afc89847f9c75eaeca697ad0815" => :el_capitan
    sha256 "b94cf7612404d7e1b2ab8b91278e1865cd81edb8bd5a9e0c8810b88e1d1f3c0e" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats; <<-EOS.undent
    You will need to set up the PATH environment variable in your
    terminal to have access to Yarn’s binaries globally. Add

      export PATH="$PATH:`yarn global bin`"

    to your profile (this may be in your .profile, .bashrc, .zshrc, etc.)
    EOS
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"yarn", "add", "jquery"
  end
end
