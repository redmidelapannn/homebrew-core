class Dtrx < Formula
  desc "Intelligent archive extraction"
  homepage "https://brettcsmith.org/2007/dtrx/"
  url "https://brettcsmith.org/2007/dtrx/dtrx-7.1.tar.gz"
  sha256 "1c9afe48e9d9d4a1caa4c9b0c50593c6fe427942716ce717d81bae7f8425ce97"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "5419cb8b5327a5770d1d8a541a11c47f9195885964af3977110a4bd752a63ff7" => :el_capitan
    sha256 "15359cfa40144872520eba6cdb132a1bfc0534b66cfd87c6efab3d57221ba66f" => :yosemite
    sha256 "571dcf2caadeedce6e48c2d8ed7cd46ab39f70452dbfbfb59f7153dbdf996423" => :mavericks
  end

  depends_on "cabextract" => :optional
  depends_on "lha" => :optional
  depends_on "unshield" => :optional
  depends_on "unrar" => :recommended
  depends_on "p7zip" => :recommended

  def install
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    system "#{bin}/dtrx", "--version"
  end
end
