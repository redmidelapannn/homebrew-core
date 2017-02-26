class TaLib < Formula
  desc "Tools for market analysis"
  homepage "http://ta-lib.org/index.html"
  url "https://downloads.sourceforge.net/project/ta-lib/ta-lib/0.4.0/ta-lib-0.4.0-src.tar.gz"
  sha256 "9ff41efcb1c011a4b4b6dfc91610b06e39b1d7973ed5d4dee55029a0ac4dc651"

  bottle do
    cellar :any
    rebuild 2
    sha256 "3a92e46331554079299c504796428c467e82b1d27079cf55014b4044ef0b1fba" => :el_capitan
    sha256 "7fea771544c6e7504ae7811c617272fae8ba50aa1c157693561825f98f62f9f8" => :yosemite
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
