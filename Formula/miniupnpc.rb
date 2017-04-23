class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "https://miniupnp.tuxfamily.org"
  url "https://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-2.0.20170421.tar.gz"
  sha256 "2354c26b236e6a08548b51629b248ccaaf19388c0806b18aae5f0484b9a82158"

  bottle do
    cellar :any
    sha256 "8bc6e9ee86aabb01fb3eda2b6468de9a5c4d944a8ca31c5ce950b0168ec52198" => :sierra
    sha256 "ce40bc8c5917c87dae9b761c66e31554f6647f46ad7bdfecaf5e3330dd25d199" => :el_capitan
    sha256 "8dfb7f42d27afbb76dee4df150e5ff929e4d391fcc21febc868a5c6c5d6cf14e" => :yosemite
  end

  def install
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end
end
