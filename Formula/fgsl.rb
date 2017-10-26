class Fgsl < Formula
  desc "Fortran bindings for the GNU Scientific Library"
  homepage "https://www.lrz.de/services/software/mathematik/gsl/fortran/"
  url "https://www.lrz.de/services/software/mathematik/gsl/fortran/download/fgsl-1.2.0.tar.gz"
  sha256 "00fd467af2bb778e8d15ac8c27ddc7b9024bb8fa2f950a868d9d24b6086e5ca7"

  bottle do
    sha256 "d8a1c1f641b3c88e7fdce6f02b24a6b40375ecdd6aee4ead90fb66b95cde6e0e" => :high_sierra
    sha256 "66e8af5490adc086b01f0df6856845e2dcf9080184ef9553a399d763a87fd154" => :sierra
    sha256 "059a656fc6e1e05cd6ec86d120c3be4b0ecfc05bc71248f2a58f0a625f668c81" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gcc"
  depends_on :fortran
  depends_on "gsl"

  def install
    ENV.deparallelize

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "CC=gcc-7",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    ENV.fortran
    system ENV.fc, "#{share}/examples/fgsl/fft.f90",
                   "-L#{lib}", "-lfgsl", "-I#{include}/fgsl", "-o", "test"
    system "./test"
  end
end
