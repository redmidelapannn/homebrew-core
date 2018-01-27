class Ranger < Formula
  desc "File browser"
  homepage "https://ranger.github.io"
  url "http://ranger.nongnu.org/ranger-1.8.1.tar.gz"
  sha256 "1433f9f9958b104c97d4b23ab77a2ac37d3f98b826437b941052a55c01c721b4"
  head "https://github.com/ranger/ranger.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9ce69a7e330502a27cb7466a6f869b570f86cc651bef02f5493ad142fbf8ef47" => :high_sierra
    sha256 "9ce69a7e330502a27cb7466a6f869b570f86cc651bef02f5493ad142fbf8ef47" => :sierra
    sha256 "9ce69a7e330502a27cb7466a6f869b570f86cc651bef02f5493ad142fbf8ef47" => :el_capitan
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
