class Mpfi < Formula
  desc "Multiple precision interval arithmetic library"
  homepage "https://perso.ens-lyon.fr/nathalie.revol/software.html"
  url "https://gforge.inria.fr/frs/download.php/30130/mpfi-1.5.1.tar.gz"
  sha256 "ea2725c6f38ddd8f3677c9b0ce8da8f52fe69e34aa85c01fb98074dc4e3458bc"

  bottle do
    cellar :any
    rebuild 1
    sha256 "07fa986cbc871c3b8d18325b8585f5aadb3e8ffd97e7ce3637ff991806daf49b" => :sierra
    sha256 "1e83bc5873c592cb82924b3ce8ef15bdf248e4a05eb3231c7118d468e777fdee" => :el_capitan
    sha256 "127e39e79fe27b25abbbebc7020d4593ca9d5d879620809acef6838daa7d4188" => :yosemite
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
    (testpath/"test.c").write <<-EOS.undent
      #include <mpfi.h>

      int main()
      {
        mpfi_t x;
        mpfi_init(x);
        mpfi_clear(x);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lgmp", "-lmpfr", "-lmpfi", "-o", "test"
    system "./test"
  end
end
