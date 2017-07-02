class Cronolog < Formula
  desc "Web log rotation"
  homepage "https://web.archive.org/web/20140209202032/cronolog.org/"
  url "https://www.mirrorservice.org/sites/distfiles.macports.org/cronolog/cronolog-1.6.2.tar.gz"
  mirror "https://fossies.org/linux/www/old/cronolog-1.6.2.tar.gz"
  sha256 "65e91607643e5aa5b336f17636fa474eb6669acc89288e72feb2f54a27edb88e"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "026970dc99d2cd46b5e94f9f2b7ea98a204b6f96509c87ac22f676d0f2c5456c" => :sierra
    sha256 "2bf1eb723a30c2f9b6ebe86d0f34e7beb0048d46fcbf430b5ff60a4825f0fd16" => :el_capitan
    sha256 "f2069cff4e5196041d7fb0f26b9dbb267afbe6ea3b4701e73888b1d63624859f" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make", "install"
  end
end
