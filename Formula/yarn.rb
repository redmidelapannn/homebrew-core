require "language/node"

class Yarn < Formula
  desc "JavaScript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.21.3/yarn-v0.21.3.tar.gz"
  sha256 "0946a4d1abc106c131b700cc31e5c3aa5f2205eb3bb9d17411f8115354a97d5d"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "66516b3da64d58bbd1d35589569b93b268f13fd8ec1f6df2a461724313f8b6bc" => :sierra
    sha256 "da10d4bd3767daad2141c03d3ff5506784c0d9033ebe9e65b309790d43f1138c" => :el_capitan
    sha256 "2e26c9ed1a9456c09e7dd06c200914a6bb1b6480d4a603c4e0296ec96a331a8a" => :yosemite
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
