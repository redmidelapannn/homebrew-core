class Fgsl < Formula
  desc "Fortran bindings for the GNU Scientific Library"
  homepage "https://www.lrz.de/services/software/mathematik/gsl/fortran/"
  url "https://www.lrz.de/services/software/mathematik/gsl/fortran/download/fgsl-1.2.0.tar.gz"
  sha256 "00fd467af2bb778e8d15ac8c27ddc7b9024bb8fa2f950a868d9d24b6086e5ca7"

  bottle do
    sha256 "c50b9f26bd6b2d05d1ee638efa5b04b1c585bfa64179c106534cfd51d470c463" => :high_sierra
    sha256 "f97008397792be588efb8c40f33cf7712afc1a56fe1be7e0dcbbe1b1385e3c03" => :sierra
    sha256 "faade644cd15a4de2a9782b3e853849f9c6c1c8eb76317b6fbf9aaa399b3362b" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gcc"
  depends_on "gsl"

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
