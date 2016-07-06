class Globe < Formula
  desc "Prints ASCII graphic of currently-lit side of the Earth"
  homepage "https://www.acme.com/software/globe/"
  url "https://www.acme.com/software/globe/globe_14Aug2014.tar.gz"
  version "0.0.20140814"
  sha256 "5507a4caaf3e3318fd895ab1f8edfa5887c9f64547cad70cff3249350caa6c86"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "c6901f4f94ff02dbe62e71f89c2a20e930e1749e5a3292370ca28903d63bc400" => :el_capitan
    sha256 "613e5139f070c83dd2e1efaf21112f9bf788fa0b35240478efb57e5f2d2a4950" => :yosemite
    sha256 "15c0208b3f3421cdbdbd8609461f4d18ac00456d6880e1af53f0771b40c6e34e" => :mavericks
  end

  def install
    bin.mkpath
    man1.mkpath

    system "make", "all", "install", "BINDIR=#{bin}", "MANDIR=#{man1}"
  end

  test do
    system "#{bin}/globe"
  end
end
