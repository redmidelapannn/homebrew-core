class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v6.3.0.tar.gz"
  sha256 "387781261d413f09f03d1ebc737da0bd28647f93f6d1f75d3cebb6b4c767fe4d"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc5255a62483cc5b8354dfacd695fc965f48f1a0e8756614d2761d8fc8450479" => :catalina
    sha256 "bc5255a62483cc5b8354dfacd695fc965f48f1a0e8756614d2761d8fc8450479" => :mojave
    sha256 "bc5255a62483cc5b8354dfacd695fc965f48f1a0e8756614d2761d8fc8450479" => :high_sierra
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
