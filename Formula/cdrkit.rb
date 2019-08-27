class Cdrkit < Formula
  desc "Collection of computer programs for CD and DVD authoring"
  homepage "https://en.wikipedia.org/wiki/Cdrkit"
  url "https://github.com/sidneys/cdrkit/archive/v2.0.0.tar.gz"
  sha256 "bf07b0e011532c1f96bbab71efe75537c5ec1614fd9636ce551fcaf56b03579c"
  head "https://github.com/sidneys/cdrkit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "048707468b989b235a86992ef6cd7948db3fa81063ef1734df52b868d701de1b" => :mojave
    sha256 "b502cb18ec0cec29aa477a39d1f03995ef352773a0f1b708c448d0b40db94d6a" => :high_sierra
    sha256 "da5bd1b599193a543762c23859c2553968227fc8b199343badcab89a5b8a9a4c" => :sierra
  end

  depends_on "cmake" => :build

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "genisoimage 1.1.11 (Darwin)", shell_output("#{bin}/genisoimage --version")
  end
end
