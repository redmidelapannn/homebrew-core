class FgslAT1 < Formula
  desc "Fortran bindings for the GNU Scientific Library v1.x"
  homepage "https://www.lrz.de/services/software/mathematik/gsl/fortran/"
  url "https://www.lrz.de/services/software/mathematik/gsl/fortran/download/fgsl-1.0.0.tar.gz"
  sha256 "2841f6deb2ce05e153fc1d89fe5e46aba74c60a2595c857cef9ca771a0cf6290"

  bottle do
    sha256 "e9438f71feafe73846348a784258a0cd46eadd9b9232d9db60e5da011d9aee99" => :high_sierra
    sha256 "e73ed18abbb72165bd26d9917500b52f97cdf2b528aa4ccfd0f34352d0698680" => :sierra
    sha256 "c12a6121328395712f498e56a3545d08f99aa87192b0aee0aa4ec091d562e5a1" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gcc"
  depends_on "gsl@1"

  def install
    ENV.deparallelize

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
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
