class Mpfi < Formula
  desc "Multiple precision interval arithmetic library"
  homepage "https://perso.ens-lyon.fr/nathalie.revol/software.html"
  url "https://gforge.inria.fr/frs/download.php/file/37331/mpfi-1.5.3.tar.bz2"
  sha256 "2383d457b208c6cd3cf2e66b69c4ce47477b2a0db31fbec0cd4b1ebaa247192f"
  revision 1

  bottle do
    cellar :any
    sha256 "eeeeb78f4420d60981acbc9a573b62de15332b8000fa342d7d4d57c5ff2d12c8" => :mojave
    sha256 "c514f9e9b758ce9456a36d2f4ca2817d3d92534d4305551b24aeaa9187645ab7" => :high_sierra
    sha256 "7bad95efa625e123d85ebcfd5e02b9346ab76b8fa45437153da16ff73bd2309e" => :sierra
  end

  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mpfi.h>

      int main()
      {
        mpfi_t x;
        mpfi_init(x);
        mpfi_clear(x);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lgmp", "-lmpfr", "-L#{lib}", "-lmpfi",
                   "-o", "test"
    system "./test"
  end
end
