class Yarn < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.17.0/yarn-v0.17.0.tar.gz"
  sha256 "bb87332c23baec5680e13c9afa858d851276eca27e33e215a84338fb4acb0026"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "22eeff5c63617494ab0ab01e0e4e9fc958cf9878a8b6173e8457ac2415dbbb1a" => :sierra
    sha256 "22eeff5c63617494ab0ab01e0e4e9fc958cf9878a8b6173e8457ac2415dbbb1a" => :el_capitan
    sha256 "22eeff5c63617494ab0ab01e0e4e9fc958cf9878a8b6173e8457ac2415dbbb1a" => :yosemite
  end

  depends_on "node"

  def install
    libexec.install buildpath.children
    bin.install_symlink Dir["#{libexec}/bin/yarn"]
    bin.install_symlink Dir["#{libexec}/bin/yarn.js"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"yarn", "add", "user-home"
  end
end
