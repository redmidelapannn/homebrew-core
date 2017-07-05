class Pbc < Formula
  desc "Pairing-based cryptography"
  homepage "https://crypto.stanford.edu/pbc/"
  url "https://crypto.stanford.edu/pbc/files/pbc-0.5.14.tar.gz"
  sha256 "772527404117587560080241cedaf441e5cac3269009cdde4c588a1dce4c23d2"
  head "http://repo.or.cz/r/pbc.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7845db6037adbb32fdbc881adfa35caf2fd31fbdca48a2f73b3a3b601d0c1ee9" => :sierra
    sha256 "9d70d9c1e35c48e3e59033437fa34977dc740ab4a3014711ba06da9409d786c9" => :el_capitan
    sha256 "785dbbd825ce3df714fe7b8ee917d1e7cd5b835a20e1bc9d3f8c505e1dc00a1e" => :yosemite
  end

  depends_on "gmp"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <pbc/pbc.h>
      #include <assert.h>

      int main()
      {
        pbc_param_t param;
        pairing_t pairing;
        element_t g1, g2, gt1, gt2, gt3, a, g1a;
        pbc_param_init_a_gen(param, 160, 512);
        pairing_init_pbc_param(pairing, param);
        element_init_G1(g1, pairing);
        element_init_G2(g2, pairing);
        element_init_G1(g1a, pairing);
        element_init_GT(gt1, pairing);
        element_init_GT(gt2, pairing);
        element_init_GT(gt3, pairing);
        element_init_Zr(a, pairing);
        element_random(g1); element_random(g2); element_random(a);
        element_pairing(gt1, g1, g2); // gt1 = e(g1, g2)
        element_pow_zn(g1a, g1, a); // g1a = g1^a
        element_pow_zn(gt2, gt1, a); // gt2 = gt1^a = e(g1, g2)^a
        element_pairing(gt3, g1a, g2); // gt3 = e(g1a, g2) = e(g1^a, g2)
        assert(element_cmp(gt2, gt3) == 0); // assert gt2 == gt3
        pairing_clear(pairing);
        element_clear(g1); element_clear(g2); element_clear(gt1);
        element_clear(gt2); element_clear(gt3); element_clear(a);
        element_clear(g1a);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lgmp", "-L#{lib}", "-lpbc", "-o", "test"
    system "./test"
  end
end
