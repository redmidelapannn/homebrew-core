class Healpix < Formula
  desc "Hierarchical Equal Area isoLatitude Pixelization of a sphere"
  homepage "https://healpix.jpl.nasa.gov"
  url "https://downloads.sourceforge.net/project/healpix/Healpix_3.50/Healpix_3.50_2018Dec10.tar.gz"
  version "3.50"
  sha256 "ec9378888ef8365f9a83fa82e3ef3b4e411ed6a63aca33b74a6917c05334bf4f"
  revision 1

  bottle do
    cellar :any
    sha256 "d1143c3c5f07b2417a9690d06c1e9cac6831172d1d69928660ecf51ebbd3d00c" => :catalina
    sha256 "7f08d34062ab7ccb89d391a479303412527b18d3244802b9c1bf3b0b29ed4b60" => :mojave
    sha256 "f8b87f40f506200f5e9a8a0b2f0f6bdecf20404750612e0638a6c2df1d0be1d5" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "cfitsio"

  def install
    configure_args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    cd "src/C/autotools" do
      system "autoreconf", "--install"
      system "./configure", *configure_args
      system "make", "install"
    end

    cd "src/cxx/autotools" do
      system "autoreconf", "--install"
      system "./configure", *configure_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cxx").write <<-EOS
      #include <math.h>
      #include <stdio.h>
      #include "chealpix.h"
      int main(void) {
        long nside, npix, pp, ns1;
        nside = 1024;
        for (pp = 0; pp < 14; pp++) {
          nside = pow(2, pp);
          npix = nside2npix(nside);
          ns1  = npix2nside(npix);
        }
      };
    EOS

    system ENV.cxx, "-o", "test", "test.cxx", "-L#{lib}", "-lchealpix"
    system "./test"
  end
end
