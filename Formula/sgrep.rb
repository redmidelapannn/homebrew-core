class Sgrep < Formula
  desc "Search SGML, XML, and HTML"
  homepage "https://www.cs.helsinki.fi/u/jjaakkol/sgrep.html"
  # curl: (9) Server denied you to change to the given directory
  # ftp://ftp.cs.helsinki.fi/pub/Software/Local/Sgrep/sgrep-1.94a.tar.gz
  url "https://www.mirrorservice.org/sites/distfiles.macports.org/sgrep2/sgrep-1.94a.tar.gz"
  mirror "https://fossies.org/linux/misc/old/sgrep-1.94a.tar.gz"
  sha256 "d5b16478e3ab44735e24283d2d895d2c9c80139c95228df3bdb2ac446395faf9"

  bottle do
    rebuild 1
    sha256 "af90afcf36b92937539dc1243569a68555cdcb0b02f44811e65366c8750c3d02" => :sierra
    sha256 "b66fc10cb5eb9bc27cf119143d70530c4ed9b815cbd6e24d6ae1827e38d42903" => :el_capitan
    sha256 "1cf66c2fb77c9f716c3532d1b3a29c20ae38ae9375e5fd0435fda0176b717527" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--datadir=#{share}/sgrep"
    system "make", "install"
  end

  test do
    input = test_fixtures("test.eps")
    assert_equal "2", shell_output("#{bin}/sgrep -c '\"mark\"' #{input}").strip
  end
end
