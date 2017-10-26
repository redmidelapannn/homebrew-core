class FgslAT1 < Formula
  desc "Fortran bindings for the GNU Scientific Library v1.x"
  homepage "https://www.lrz.de/services/software/mathematik/gsl/fortran/"
  url "https://www.lrz.de/services/software/mathematik/gsl/fortran/download/fgsl-1.0.0.tar.gz"
  sha256 "2841f6deb2ce05e153fc1d89fe5e46aba74c60a2595c857cef9ca771a0cf6290"

  bottle do
    sha256 "b9ff13098dad604ccfcb99fbb006f22b8295f9993afb6b55501890cca7e64f1c" => :high_sierra
    sha256 "92fec4561dacf5c245bc168e6f90ca632417679779c6219b0a8d3978c14792e7" => :sierra
    sha256 "01749e4892d6ec640a13339c758460b18d935440d317346be6074dfadffc0850" => :el_capitan
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
