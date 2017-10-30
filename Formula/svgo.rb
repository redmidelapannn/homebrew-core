require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/v1.0.0.tar.gz"
  sha256 "b3761a476f4afed2edc70da1407b95ff00f4d1da54c60a003ae266c84d40216e"

  bottle do
    cellar :any_skip_relocation
    sha256 "517006e9a59ba65162ad69539e0469312b613198663081f49639ff7ad2b33335" => :high_sierra
    sha256 "edb1b3425f50dfecf2175f5c7e8c983646536e696c0e61e3f910cef04e6a7804" => :sierra
    sha256 "918c399c7256d7fa3208697292048e5f7f06892a55f7c577e88d3352e45c4224" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    cp test_fixtures("test.svg"), testpath
    system bin/"svgo", "test.svg", "-o", "test.min.svg"
    assert_match /^<svg /, (testpath/"test.min.svg").read
  end
end
