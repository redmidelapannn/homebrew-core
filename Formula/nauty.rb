class Nauty < Formula
  desc "Automorphism groups of graphs and digraphs"
  homepage "http://pallini.di.uniroma1.it"
  url "http://pallini.di.uniroma1.it/nauty26r12.tar.gz"
  version "26r12"
  sha256 "862ae0dc3656db34ede6fafdb0999f7b875b14c7ab4fedbb3da4f28291eb95dc"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a0c0b6f3c1e1d8fd3225042a33c571a3ad07a3277f310d3e53e3e28e81970317" => :catalina
    sha256 "f8270cde74c40df8323f12e951ee83c40b0868679089f42e9d6e359e751d380b" => :mojave
    sha256 "58340c90765428ce33e3357fd080ad56a897fa76fb96fc573b1ef6d58baf3122" => :high_sierra
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "all"
    system "make", "nauty.a"

    bin.install %w[
      NRswitchg addedgeg amtog biplabg catg complg converseg copyg countg
      cubhamg deledgeg delptg directg dreadnaut dretodot dretog genbg genbgL
      geng genquarticg genrang genspecialg gentourng gentreeg hamheuristic
      labelg linegraphg listg multig newedgeg pickg planarg ranlabg shortg
      showg subdivideg twohamg vcolg watercluster2
    ]

    include.install "nauty.h"

    lib.install "nauty.a" => "libnauty.a"

    doc.install "nug26.pdf"
  end

  test do
    # from ./runalltests
    out1 = shell_output("#{bin}/geng -ud1D7t 11 2>&1")
    out2 = shell_output("#{bin}/genrang -r3 114 100 | #{bin}/countg --nedDr -q")

    assert_match /92779 graphs generated/, out1
    assert_match /100 graphs : n=114; e=171; mindeg=3; maxdeg=3; regular/, out2

    # test that the library is installed and linkable-against
    (testpath/"test.c").write <<~EOS
      #define MAXN 1000
      #include <nauty.h>

      int main()
      {
        int n = 12345;
        int m = SETWORDSNEEDED(n);
        nauty_check(WORDSIZE, m, n, NAUTYVERSIONID);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lnauty", "-o", "test"
    system "./test"
  end
end
