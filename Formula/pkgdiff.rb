class Pkgdiff < Formula
  desc "Tool for analyzing changes in software packages (e.g. RPM, DEB, TAR.GZ)"
  homepage "https://lvc.github.io/pkgdiff/"
  url "https://github.com/lvc/pkgdiff/archive/1.7.2.tar.gz"
  sha256 "d0ef5c8ef04f019f00c3278d988350201becfbe40d04b734defd5789eaa0d321"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "361994c5d363c49ddad10d1f186dd7131f867e8298085a4dcdfcdd925957fd76" => :high_sierra
    sha256 "361994c5d363c49ddad10d1f186dd7131f867e8298085a4dcdfcdd925957fd76" => :sierra
    sha256 "361994c5d363c49ddad10d1f186dd7131f867e8298085a4dcdfcdd925957fd76" => :el_capitan
  end

  depends_on "wdiff"
  depends_on "gawk"
  depends_on "binutils" => :recommended
  depends_on "rpm" => :optional
  depends_on "dpkg" => :optional

  def install
    system "perl", "Makefile.pl", "--install", "--prefix=#{prefix}"
  end

  test do
    system bin/"pkgdiff"
  end
end
