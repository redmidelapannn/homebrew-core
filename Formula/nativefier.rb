require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-7.6.6.tgz"
  sha256 "6032f02e9a07c9f8dce6ccddb3596d4dda75f228f5160ac51cb2fb47b1b1c7cc"

  bottle do
    cellar :any_skip_relocation
    sha256 "71083e0c7e4de4ff0a788d233a007dfbd8a95b6df857396d4bd86e6cea5eae5a" => :high_sierra
    sha256 "699de1684a6102b1c1d89a91daa401d093dcfb97f948f1b66564723271baa3c9" => :sierra
    sha256 "1b88edf68a46655b22d98d5765c38c2a4b58ab136fc92e1f17e37d004d7f5cad" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"nativefier", "--version"
  end
end
