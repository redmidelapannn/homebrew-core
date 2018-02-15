class Ppl < Formula
  desc "Parma Polyhedra Library: numerical abstractions for analysis, verification"
  homepage "https://bugseng.com/ppl"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/p/ppl/ppl_1.2.orig.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/p/ppl/ppl_1.2.orig.tar.xz"
  sha256 "691f0d5a4fb0e206f4e132fc9132c71d6e33cdda168470d40ac3cf62340e9a60"

  bottle do
    rebuild 1
    sha256 "40aec16b022fca20619e88f0534da4232ed538308100f7669755d9b61bc4697f" => :high_sierra
    sha256 "df7bb904392db79497637fcdf80936aa02d82555816121469a3651bf0d04902d" => :sierra
    sha256 "a62fdc166a1cddffcc3f31c458bf744ddbe68e3783b90745065fab41edb1b172" => :el_capitan
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
