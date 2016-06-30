require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler. Built for speed."
  homepage "https://github.com/chjj/marked"
  url "https://github.com/chjj/marked/archive/v0.3.5.tar.gz"
  sha256 "4a9cb612dd9fa4a10f9c43e252626b568a5beead2e3fa02f7b0e4f71f8453adc"
  head "https://github.com/chjj/marked.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "34d6a64cdbbef4d14ca8729590b799b44529cc333b0886bac772308258804cfa" => :el_capitan
    sha256 "8074b2bdb80dade78c08c23b54fbeb88339c7ff6b1816f8ff6e1fe225d48fb2f" => :yosemite
    sha256 "1a0879416cca100b468b011b73bca2865158e2d4bbe9a237f0b6ce7848c04965" => :mavericks
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/marked"]
  end

  test do
    system bin/"marked", "-h"
  end
end
