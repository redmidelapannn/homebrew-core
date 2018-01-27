class Ppl < Formula
  desc "Parma Polyhedra Library: numerical abstractions for analysis, verification"
  homepage "http://bugseng.com/products/ppl"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/p/ppl/ppl_1.2.orig.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/p/ppl/ppl_1.2.orig.tar.xz"
  sha256 "691f0d5a4fb0e206f4e132fc9132c71d6e33cdda168470d40ac3cf62340e9a60"

  bottle do
    rebuild 1
    sha256 "0f90152186efe58ab83046d3df63009ec2b9c4ab03e8ac6bcfb06ef41a0912dd" => :high_sierra
    sha256 "0c0b897dabd4aa154d861ca13be91a4ff1f4feff9a87b89749aed361e78fa80b" => :sierra
    sha256 "486b81107cdcc471310ce84edf1c221de9cee6cbf42a3d912f8658debc4ce118" => :el_capitan
  end

  depends_on "gmp"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-gmp=#{Formula["gmp"].opt_prefix}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <ppl_c.h>
      #ifndef PPL_VERSION_MAJOR
      #error "No PPL header"
      #endif
      int main() {
        ppl_initialize();
        return ppl_finalize();
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lppl_c", "-lppl", "-o", "test"
    system "./test"
  end
end
