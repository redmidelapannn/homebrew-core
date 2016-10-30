class Gnugo < Formula
  desc "The GNU program to play the game of Go"
  homepage "https://www.gnu.org/software/gnugo/gnugo.html"
  url "https://ftpmirror.gnu.org/gnugo/gnugo-3.8.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gnugo/gnugo-3.8.tar.gz"
  sha256 "da68d7a65f44dcf6ce6e4e630b6f6dd9897249d34425920bfdd4e07ff1866a72"

  bottle do
    cellar :any_skip_relocation
    sha256 "85ff84f9d2dc6cab0e4858206e4f51b91c2c2c4fa8a81dd7904a1527f9a8289f" => :sierra
    sha256 "38067f4008f32c4c721e22d766cd4490dc2c264d531f04d4f4e9dac319527720" => :el_capitan
    sha256 "c1f67fc351877bb6e460f046859c423ca040cb573f8788fd35cdbe11bca7f4f1" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/gnugo", "--version"
  end
end
