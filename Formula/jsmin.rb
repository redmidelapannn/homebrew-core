class Jsmin < Formula
  desc "Minify JavaScript code"
  homepage "https://www.crockford.com/javascript/jsmin.html"
  url "https://github.com/douglascrockford/JSMin/archive/1bf6ce5f74a9f8752ac7f5d115b8d7ccb31cfe1b.tar.gz"
  version "2013-03-29"
  sha256 "aae127bf7291a7b2592f36599e5ed6c6423eac7abe0cd5992f82d6d46fe9ed2d"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "73395fd0a3e31d1b9fb5961f14522a2dc31676a1476d71f6f51b8ae993ce6c6e" => :sierra
    sha256 "b38783593431d12cc861efcc5ab2cf745d475c1b923c61b75aa33ba60d94b256" => :el_capitan
    sha256 "f8c5455f1ef7ff5b324ddb353652459dc4d1e43b33fe1ac765784b81b1224d9f" => :yosemite
  end

  def install
    system ENV.cc, "jsmin.c", "-o", "jsmin"
    bin.install "jsmin"
  end

  test do
    assert_equal "\nvar i=0;", pipe_output(bin/"jsmin", "var i = 0; // comment")
  end
end
