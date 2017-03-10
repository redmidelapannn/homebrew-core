class GnuGo < Formula
  desc "GNU Go"
  homepage "https://www.gnu.org/software/gnugo/gnugo.html"
  url "https://ftpmirror.gnu.org/gnugo/gnugo-3.8.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gnugo/gnugo-3.8.tar.gz"
  sha256 "da68d7a65f44dcf6ce6e4e630b6f6dd9897249d34425920bfdd4e07ff1866a72"
  revision 1
  head "https://git.savannah.gnu.org/git/gnugo.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "76ea7e310cf5ec26a9e49c01b45ab993e80dab8c5ac68bec797afef160b4f3f5" => :sierra
    sha256 "02db5b75d5177eb10847619f782534f2811560620330b34d78815dfda17f3faa" => :el_capitan
    sha256 "71f75677540e2601e9492b6c9a89af2b4b91245316d2dc338acfe8b030fd09d4" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline"
    system "make", "install"
  end

  test do
    assert_match /GNU Go #{version}$/, shell_output("#{bin}/gnugo --version")
  end
end
