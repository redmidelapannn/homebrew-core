class Gcal < Formula
  desc "Program for calculating and printing calendars"
  homepage "https://www.gnu.org/software/gcal/"
  url "https://ftpmirror.gnu.org/gcal/gcal-4.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gcal/gcal-4.tar.xz"
  sha256 "59c5c876b12ec70649d90e2ce76afbe2f4ed93503d49ec39e5c575b3aef8ff6e"

  bottle do
    cellar :any_skip_relocation
    revision 3
    sha256 "fbe42347ddde707d847d215350a19d2a0356e54614b289cde17b8ecb7f8156c4" => :el_capitan
    sha256 "dab7e957c76dd7ff92202fcc25da0f78fd35639edaa9a3cb84442a97d2a9a3a8" => :yosemite
    sha256 "1bdd191c291099197c7a9856106ef66da35be1912ad2a685e50eead31e4b80d7" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
    system "make", "-C", "doc/en", "html"
    doc.install "doc/en/gcal.html"
  end

  test do
    date = shell_output("date +%Y")
    assert_match date, shell_output("#{bin}/gcal")
  end
end
