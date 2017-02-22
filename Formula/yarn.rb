require "language/node"

class Yarn < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.21.2/yarn-v0.21.2.tar.gz"
  sha256 "1ccd5676112dd1aa99759cde942f9c2e9ec22c15977f910d8d298210deb6797e"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "66745fbc4ee9c44b98462bbcd18b688ad88e4251de720ed8e01c9d648cb7dab9" => :sierra
    sha256 "7c3bc24d226bf1f0641126b5a1325c294e30689ddc991847509342994e2c6978" => :el_capitan
    sha256 "ec3e8608f01ca685f051464d98a4aae111112b44cf292fc783ea38c25e3f9d83" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"yarn", "add", "jquery"
  end
end
