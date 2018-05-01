require "language/node"

class Bower < Formula
  desc "Package manager for the web"
  homepage "https://bower.io/"
  url "https://registry.npmjs.org/bower/-/bower-1.8.4.tgz"
  sha256 "e5071eca9d4b69aee04f8dc5cea0304b259b496e969c7e997e8b6fc3089857af"

  bottle do
    cellar :any_skip_relocation
    sha256 "1cf7a366cc02d903cfaa9f8ed4f10bdf43a82798c46cd22f0301bb5bc9c963c1" => :high_sierra
    sha256 "744f0d2069a4fc20410d9d7129502f990ee3bb2ef73efe240771f5f9aef56e22" => :sierra
    sha256 "05bab68e28e5cb726bf5953a4d8ace22382177f0a71c40a09bea33bb6de410c3" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"bower", "install", "jquery"
    assert_predicate testpath/"bower_components/jquery/dist/jquery.min.js", :exist?, "jquery.min.js was not installed"
  end
end
