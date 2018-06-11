require "language/node"

class Svgexport < Formula
  desc "SVG to PNG/JPEG export tool"
  homepage "https://github.com/shakiba/svgexport"
  url "https://registry.npmjs.org/svgexport/-/svgexport-0.3.2.tgz"
  sha256 "878f2faf89d67e9a73e32101ea486e5123a6bc6137278a403da8c7bc7743c113"

  bottle do
    cellar :any_skip_relocation
    sha256 "854a2a9c2b804cc33294acaab43a739b86ea856884a87f09b3d7f117887bd741" => :high_sierra
    sha256 "9c542a45429fb64e28881dad013fda3cdc205f8a08792dbcc5c2d3d6dc83b306" => :sierra
    sha256 "eb2067cc55b9965f274468d23c71da1b62288e551e7cd4057315a9afc29e1a2e" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    cp test_fixtures("test.svg"), testpath/"test.svg"
    system bin/"svgexport", testpath/"test.svg", testpath/"test.png"
    assert_predicate testpath/"test.png", :exist?
  end
end
