class Bashish < Formula
  desc "Theme environment for text terminals"
  homepage "https://bashish.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bashish/bashish/2.2.4/bashish-2.2.4.tar.gz"
  sha256 "3de48bc1aa69ec73dafc7436070e688015d794f22f6e74d5c78a0b09c938204b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f76afe84f950c3f4b7e67cfceecdf77f52226b680b1bc2fc1b0e842ae793f0d1" => :mojave
    sha256 "f76afe84f950c3f4b7e67cfceecdf77f52226b680b1bc2fc1b0e842ae793f0d1" => :high_sierra
  end

  depends_on "dialog"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/bashish", "list"
  end
end
