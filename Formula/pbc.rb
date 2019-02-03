class Pbc < Formula
  desc "Pairing-based cryptography"
  homepage "https://crypto.stanford.edu/pbc/"
  url "https://crypto.stanford.edu/pbc/files/pbc-0.5.14.tar.gz"
  sha256 "772527404117587560080241cedaf441e5cac3269009cdde4c588a1dce4c23d2"
  revision 1
  head "https://repo.or.cz/pbc.git"

  bottle do
    cellar :any
    sha256 "7561813f8af15e6232f9fffae558e83b9e8312d6b23db93f22a52c49433d3088" => :mojave
    sha256 "391d57bdb23a33505ae05ae1d5192d1269ebcafa71ae6d08750ef504406bb3c7" => :high_sierra
    sha256 "5a587809402cb581732ee0f28b45f70f98643bc22e728505be4fc9bd929cad28" => :sierra
  end

  depends_on "gmp"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
