require "language/node"

class NowCli < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-16.7.3.tgz"
  sha256 "f8f918995a6f3f597ee9bdcf5d2330a35c65ac17690d03a12a0b06272f3c3250"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7103f294becb9bd20e0e687dc87509bb6af2d57797cc57fbe7e6048f13143765" => :catalina
    sha256 "b2a2a817b023910dd509372abc2b0efe12a05906cc8e82cd0f02bb7f82abce4c" => :mojave
    sha256 "fe5a58b28a98391ae872032e2a1d43180fd9d8a010f8324749e828587b0bff17" => :high_sierra
  end

  depends_on "node"

  def install
    rm Dir["dist/{*.exe,xsel}"]
    inreplace "dist/index.js", "t.default=getUpdateCommand",
                               "t.default=async()=>'brew upgrade now-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/now", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
