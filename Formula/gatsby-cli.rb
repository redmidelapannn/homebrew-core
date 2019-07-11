require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.7.9.tgz"
  sha256 "d53994f4ec4d009f99f6bc8f0cd60053b124ea124132c8c5685ad296c4729a5e"

  bottle do
    cellar :any_skip_relocation
    sha256 "f58f5d6bce6254fa512a19111f2f24f792464d882b8201c58c8753a6f5fcaf75" => :mojave
    sha256 "5de3104ed495790f1a5a3dadfc3aa9cc54897f58c813eefdfa7b00437a4fe5ab" => :high_sierra
    sha256 "2f34d0411e7b4b6e6dc3bcd9eac8c2e7d1166ba6670fa9c953bce73ccbe29750" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
