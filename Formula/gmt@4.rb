class GmtAT4 < Formula
  desc "Manipulation of geographic and Cartesian data sets"
  homepage "https://gmt.soest.hawaii.edu/"
  url "ftp://ftp.soest.hawaii.edu/gmt/gmt-4.5.18-src.tar.bz2"
  mirror "https://fossies.org/linux/misc/GMT/gmt-4.5.18-src.tar.bz2"
  mirror "https://mirrors.ustc.edu.cn/gmt/gmt-4.5.18-src.tar.bz2"
  sha256 "27c30b516c317fed8e44efa84a0262f866521d80cfe76a61bf12952efb522b63"
  revision 6

  bottle do
    sha256 "f5639f5db194b06ba95dd3e75ff8979edd64626ef7d3bb2bfae762ebd9d7d61d" => :catalina
    sha256 "e572477542153e197687fabdae2911b58b9fc063aa275138460fc52bc3acec60" => :mojave
    sha256 "743a39906c0aa3df21b353140b83c0630153d078231adc90830982e6e458eac0" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on "gdal"
  depends_on "netcdf"

  resource "gshhg" do
    url "ftp://ftp.soest.hawaii.edu/gmt/gshhg-gmt-2.3.7.tar.gz"
    mirror "https://fossies.org/linux/misc/GMT/gshhg-gmt-2.3.7.tar.gz"
    mirror "https://mirrors.ustc.edu.cn/gmt/gshhg-gmt-2.3.7.tar.gz"
    sha256 "9bb1a956fca0718c083bef842e625797535a00ce81f175df08b042c2a92cfe7f"
  end

  def install
    ENV.deparallelize # Parallel builds don't work due to missing makefile dependencies
    system "./configure", "--prefix=#{prefix}",
                          "--datadir=#{share}/gmt4",
                          "--enable-gdal=#{Formula["gdal"].opt_prefix}",
                          "--enable-netcdf=#{Formula["netcdf"].opt_prefix}",
                          "--enable-shared",
                          "--enable-triangle",
                          "--disable-xgrid",
                          "--disable-mex"
    system "make"
    system "make", "install-gmt", "install-data", "install-suppl", "install-man"
    (share/"gmt4").install resource("gshhg")
  end

  test do
    system "#{bin}/gmt pscoast -R-90/-70/0/20 -JM6i -P -Ba5 -Gchocolate > test.ps"
    assert_predicate testpath/"test.ps", :exist?
  end
end
