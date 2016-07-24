class Bogofilter < Formula
  desc "Mail filter via statistical analysis"
  homepage "http://bogofilter.sourceforge.net"
  url "https://downloads.sourceforge.net/project/bogofilter/bogofilter-1.2.4/bogofilter-1.2.4.tar.bz2"
  sha256 "e10287a58d135feaea26880ce7d4b9fa2841fb114a2154bf7da8da98aab0a6b4"
  revision 1

  bottle do
    sha256 "2197d7dc9ccfe26cb939461fde3c24ad32cdc5c639019cb5f45a0a7f8171ed0b" => :el_capitan
    sha256 "1126b712f2fec88b664e29c4f290d608a6c74d9b299389e41a7fb07f14c23947" => :yosemite
    sha256 "b6059c9bed61e3e2d55fabe2ce071f77c0af74b865239895188d4130904ab313" => :mavericks
  end

  depends_on "berkeley-db"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
