class Wandio < Formula
  desc "LibWandio I/O performance will be improved by doing any compression"
  homepage "https://research.wand.net.nz/software/libwandio.php"
  url "https://research.wand.net.nz/software/wandio/wandio-1.0.4.tar.gz"
  sha256 "0fe4ae99ad7224f11a9c988be151cbdc12c6dc15872b67f101764d6f3fc70629"

  bottle do
    cellar :any
    rebuild 1
    sha256 "cd763d9f848b3f7e606bad81cc6be055443536b6c8bb4ee7de26a04eacc48345" => :sierra
    sha256 "d4376ac6a25ad3e222b2bcf6cf0680566759415dbf0448f5ea2db0b23535c02e" => :el_capitan
    sha256 "3f33970e47c8c2e0cdf954aa04c025892faf1fd174a8e496841f45e1a2e8a9f3" => :yosemite
  end

  def install
    system "./configure", "--disable-debug",
                          "--with-http",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/wandiocat", "-h"
  end
end
