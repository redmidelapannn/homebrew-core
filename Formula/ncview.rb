class Ncview < Formula
  desc "Visual browser for netCDF format files"
  homepage "https://web.archive.org/web/20190806213507/meteora.ucsd.edu/~pierce/ncview_home_page.html"
  url "ftp://cirrus.ucsd.edu/pub/ncview/ncview-2.1.8.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/ncview--2.1.8.tar.gz"
  sha256 "e8badc507b9b774801288d1c2d59eb79ab31b004df4858d0674ed0d87dfc91be"
  revision 2

  bottle do
    sha256 "253989e875740d1dd784b429bbe957e45ee97a98fd35ce77546cdd960b813b28" => :catalina
    sha256 "3478e89380857e73a7c8cc65f140dbae6613978ba08856da617450792fa20be0" => :mojave
    sha256 "ce1ea4002799341a4d3edea918cde4fe8dad5c3b2c82e83e71ee7e1564dc09a6" => :high_sierra
  end

  depends_on "libpng"
  depends_on "netcdf"
  depends_on "udunits"
  depends_on :x11

  def install
    # Bypass compiler check (which fails due to netcdf's nc-config being
    # confused by our clang shim)
    inreplace "configure",
      "if test x$CC_TEST_SAME != x$NETCDF_CC_TEST_SAME; then",
      "if false; then"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    man1.install "data/ncview.1"
  end

  test do
    assert_match "Ncview #{version}",
                 shell_output("#{bin}/ncview -c 2>&1", 1)
  end
end
