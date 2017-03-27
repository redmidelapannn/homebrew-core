class Chmlib < Formula
  desc "Library for dealing with Microsoft ITSS/CHM files"
  homepage "http://www.jedrea.com/chmlib"
  url "http://www.jedrea.com/chmlib/chmlib-0.40.tar.gz"
  mirror "https://download.tuxfamily.org/slitaz/sources/packages/c/chmlib-0.40.tar.gz"
  sha256 "512148ed1ca86dea051ebcf62e6debbb00edfdd9720cde28f6ed98071d3a9617"

  bottle do
    cellar :any
    rebuild 3
    sha256 "bd3ef49ccaf58c4b16e5160183d47c6a22755d0a58dfda751a8f94d342c976d1" => :sierra
    sha256 "e84c3165a5cd4b0d30cf8ad0981be1ad8afe7b76201260039c37e81b8a839408" => :el_capitan
    sha256 "e9bc007b6f6b2e1d720109341a8b8b0fe584dd9916f3487219870135376d10ea" => :yosemite
  end

  def install
    system "./configure", "--disable-io64", "--enable-examples", "--prefix=#{prefix}"
    system "make", "install"
  end
end
