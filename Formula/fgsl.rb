class Fgsl < Formula
  desc "Fortran bindings for the GNU Scientific Library"
  homepage "https://www.lrz.de/services/software/mathematik/gsl/fortran/"
  url "https://www.lrz.de/services/software/mathematik/gsl/fortran/download/fgsl-1.2.0.tar.gz"
  sha256 "00fd467af2bb778e8d15ac8c27ddc7b9024bb8fa2f950a868d9d24b6086e5ca7"

  bottle do
    sha256 "883e1e82ea8ecded590e8dd7f4b69dad23134205c53f139f08895b10e4eb8bc6" => :high_sierra
    sha256 "b730c0568be7b89369275bbe4c8350077f972e51a219082a827f1a19ce1ad3a7" => :sierra
    sha256 "0f0914ce8afdc1b753d1c7fa3061e6ee9077481d1868bfcbe707a7fccb890018" => :el_capitan
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
