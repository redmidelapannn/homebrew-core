class WCalc < Formula
  desc "Very capable calculator"
  homepage "http://w-calc.sourceforge.net"
  url "https://downloads.sourceforge.net/w-calc/wcalc-2.5.tar.bz2"
  sha256 "0e2c17c20f935328dcdc6cb4c06250a6732f9ee78adf7a55c01133960d6d28ee"

  bottle do
    cellar :any
    revision 1
    sha256 "d5644c636625eb8878de503f2e8a1e6dddeb48566d92dc5f498bcbd42b943578" => :el_capitan
    sha256 "9e113a75f26d54099322f78e26ab7afd033dcd1ddc61c4ad1e71218c4d5134fd" => :yosemite
    sha256 "e1722d911d1e2af4a9963c938c60288cbb6b34168d7cb6e369f7b2b69dfa49dc" => :mavericks
  end

  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/wcalc", "2+2"
  end
end
