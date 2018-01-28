class Ranger < Formula
  desc "File browser"
  homepage "https://ranger.github.io"
  url "https://ranger.github.io/ranger-1.9.0.tar.gz"
  sha256 "64ba1eecee54dce0265c36eb87edaf4211a462dc0cb6c831113a232829fecfd9"
  head "https://github.com/ranger/ranger.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ffeb3af4c1a0dd57b14e7af356c7c14c8df3c137b714643d5e87311b17fbef04" => :high_sierra
    sha256 "ffeb3af4c1a0dd57b14e7af356c7c14c8df3c137b714643d5e87311b17fbef04" => :sierra
    sha256 "ffeb3af4c1a0dd57b14e7af356c7c14c8df3c137b714643d5e87311b17fbef04" => :el_capitan
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
