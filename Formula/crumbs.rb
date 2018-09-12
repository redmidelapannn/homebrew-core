class Crumbs < Formula
  desc "Command-line bookmarking system for sh like consoles"
  homepage "https://github.com/fasseg/crumbs"
  url "https://github.com/fasseg/crumbs/archive/0.0.1.tar.gz"
  sha256 "5a799dbde93b7eb51050380c46a96e08547169b2642689b0a921bff687bc80fc"

  bottle do
    sha256 "7778a286d7f379e2d1714a765d3ae6d1d6dc480553ae65e5dcf1aa36d877814e" => :mojave
    sha256 "704bc9e673a5ee809cec3c4e2a0a8cf494842000fd4203f6c108bbcb3b95e6ea" => :high_sierra
    sha256 "a5cd0c1a8f1e58f8f40f298c531b0ad9f417c6fab97fb99ad9c4df334efce02e" => :sierra
    sha256 "94330ffb7706ceac600dc7c4f0b18b31c7b1f5d946154dc28701523f701cda13" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/crumbs", "--help"
  end
end
