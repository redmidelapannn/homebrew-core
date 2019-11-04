require "language/node"

class ImageoptimCli < Formula
  desc "CLI for ImageOptim, ImageAlpha and JPEGmini"
  homepage "https://jamiemason.github.io/ImageOptim-CLI/"
  url "https://github.com/JamieMason/ImageOptim-CLI/archive/3.0.2.tar.gz"
  sha256 "957261d38fa85e0ec377efb2eceae695e3d87b621bae64853f9f5163efd3594b"

  bottle do
    cellar :any_skip_relocation
    sha256 "56a9b2dba8f47850a26c335311f8c436b683c0b92ef5ab0b83e91688cf64ec7a" => :catalina
    sha256 "b7b1923ed31ab32540a5dffcf798675401ca48249fae54f49d67bc6c78feede9" => :mojave
    sha256 "6f1aa4b2e4de3e7a1502f1f8747283589697e5f0f0506f4d24acd53381311706" => :high_sierra
  end

  depends_on "node@10" => :build
  depends_on "yarn" => :build

  def install
    system "yarn"
    system "npm", "run", "build"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/imageoptim -V").chomp
  end
end
