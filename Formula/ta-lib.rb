class TaLib < Formula
  desc "Tools for market analysis"
  homepage "https://ta-lib.org/"
  url "https://downloads.sourceforge.net/project/ta-lib/ta-lib/0.4.0/ta-lib-0.4.0-src.tar.gz"
  sha256 "9ff41efcb1c011a4b4b6dfc91610b06e39b1d7973ed5d4dee55029a0ac4dc651"

  bottle do
    cellar :any
    rebuild 2
    sha256 "06b1cafd100383f70009d7f6f6c08e752c39159179f38ad02810bdacc47f42cf" => :sierra
    sha256 "fa26c1718ca676dd780b51d14e22e25c86960e21fc359b0fa216ddf08f9565c6" => :el_capitan
    sha256 "e2e849959867029551543685c88bf4714e2eb217fa45aaecdfb5577984a45f4b" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    bin.install "src/tools/ta_regtest/.libs/ta_regtest"
  end

  test do
    system "#{bin}/ta_regtest"
  end
end
