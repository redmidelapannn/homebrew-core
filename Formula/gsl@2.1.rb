class GslAT21 < Formula
  desc "Numerical library for C and C++"
  homepage "https://www.gnu.org/software/gsl/"
  url "https://ftp.gnu.org/gnu/gsl/gsl-2.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/gsl/gsl-2.1.tar.gz"
  sha256 "59ad06837397617f698975c494fe7b2b698739a59e2fcf830b776428938a0c66"

  bottle do
    cellar :any
    sha256 "acc1cf28c3515d98889d2fcebc2d4d5758905dee224cc54bffbdba5e92437437" => :high_sierra
    sha256 "13c810955db8f72258d2bc110e985cd642580a5837ad9ee4f8caf2187025907f" => :sierra
    sha256 "bee7c2afddd7c18f0c02e03a73ae450fea270eae35dd726561b83756ae7e6d25" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make" # A GNU tool which doesn't support just make install! Shameful!
    system "make", "install"
  end

  test do
    system bin/"gsl-randist", "0", "20", "cauchy", "30"
  end
end
