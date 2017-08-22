class Ranger < Formula
  desc "File browser"
  homepage "http://ranger.nongnu.org/"
  url "http://ranger.nongnu.org/ranger-1.8.1.tar.gz"
  sha256 "1433f9f9958b104c97d4b23ab77a2ac37d3f98b826437b941052a55c01c721b4"
  head "https://github.com/ranger/ranger.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "cfb104dcfce5b213bbbc962f43b64a2cf6621aed3aa33c0f55385163123ce6bc" => :sierra
    sha256 "cfb104dcfce5b213bbbc962f43b64a2cf6621aed3aa33c0f55385163123ce6bc" => :el_capitan
    sha256 "cfb104dcfce5b213bbbc962f43b64a2cf6621aed3aa33c0f55385163123ce6bc" => :yosemite
  end

  def install
    man1.install "doc/ranger.1"
    libexec.install "ranger.py", "ranger"
    bin.install_symlink libexec+"ranger.py" => "ranger"
    doc.install "examples"
  end

  test do
    assert_match version.to_s, shell_output("script -q /dev/null #{bin}/ranger --version")
  end
end
