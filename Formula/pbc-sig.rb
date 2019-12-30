class PbcSig < Formula
  desc "Signatures library"
  homepage "https://crypto.stanford.edu/pbc/sig/"
  url "https://crypto.stanford.edu/pbc/sig/files/pbc_sig-0.0.8.tar.gz"
  sha256 "7a343bf342e709ea41beb7090c78078a9e57b833454c695f7bcad2475de9c4bb"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6b4fa0f796721528e35307924c41d8fa246e7f2bb11392dbd7861f57efa38409" => :catalina
    sha256 "5f5d2fb0fb2778a1f736b72a5ee00c8708c87dab8654ad7d45d037ef634aa8ca" => :mojave
    sha256 "a87389b91312e7c40c7003fbcbc33eb9f2fff6f320841012bf95e03cdfb2c890" => :high_sierra
  end

  depends_on "pbc"

  # https://groups.google.com/forum/#!topic/pbc-devel/ZmFCHZmrhcw
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <pbc/pbc.h>
      #include <pbc/pbc_sig.h>

      int main()
      {
        pbc_param_t param;
        pairing_t pairing;
        bls_sys_param_t bls_param;
        pbc_param_init_a_gen(param, 160, 512);
        pairing_init_pbc_param(pairing, param);
        bls_gen_sys_param(bls_param, pairing);
        bls_clear_sys_param(bls_param);
        pairing_clear(pairing);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lpbc", "-lpbc_sig"
    system "./test"
  end
end

__END__
diff --git a/sig/bbs.c b/sig/bbs.c
index ed1b437..8aa8331 100644
--- a/sig/bbs.c
+++ b/sig/bbs.c
@@ -1,4 +1,5 @@
 //see Boneh, Boyen and Shacham, "Short Group Signatures"
+#include <stdint.h>
 #include <pbc/pbc_utils.h>
 #include "pbc_sig.h"
 #include "pbc_hash.h"
