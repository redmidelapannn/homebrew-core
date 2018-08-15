class Qd < Formula
  desc "C++/Fortran-90 double-double and quad-double package"
  homepage "https://crd.lbl.gov/~dhbailey/mpdist/"
  url "https://crd.lbl.gov/~dhbailey/mpdist/qd-2.3.20.tar.gz"
  sha256 "da24571ceaad08abe9257ab4f45df939d17ecc9ba30df53458ec0b629a7c9167"
  revision 1

  bottle do
    cellar :any
    sha256 "55931659c8ec34508f4c9411b8f4f965611e108b7f471ec5bea2a7b9705609b7" => :high_sierra
    sha256 "a0ac5dd22c575e04cffede2d5dbd663f3cdbaa8c3ec59682c9be13e97fc61820" => :sierra
    sha256 "713c69281481a9e21af88fb718481ff949afc8ad8ae7c6fd4b4304c0436b400a" => :el_capitan
  end

  depends_on "gcc" # for gfortran

  def install
    system "./configure", "--disable-dependency-tracking", "--enable-shared",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qd-config --configure-args")
  end
end
