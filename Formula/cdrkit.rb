class Cdrkit < Formula
  desc "Collection of computer programs for CD and DVD authoring"
  homepage "https://en.wikipedia.org/wiki/Cdrkit"
  url "https://github.com/sidneys/cdrkit/archive/v2.0.0.tar.gz"
  sha256 "bf07b0e011532c1f96bbab71efe75537c5ec1614fd9636ce551fcaf56b03579c"
  head "https://github.com/sidneys/cdrkit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ec48a37516f7b40ca61d6cdc24619522f3b6f971a408d3ead02609cfa470931" => :mojave
    sha256 "30bc7e57b178e230692b648a7966802ab3cd693b4eff28ac373d274b00681038" => :high_sierra
    sha256 "aa6359ad119f329179f3678934e29223d893c5c03198025d69afe746581aacf4" => :sierra
  end

  depends_on "cmake" => :build

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "genisoimage 1.1.11 (Darwin)", shell_output("#{bin}/genisoimage --version")
  end
end
