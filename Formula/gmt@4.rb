class GmtAT4 < Formula
  desc "Manipulation of geographic and Cartesian data sets"
  homepage "https://gmt.soest.hawaii.edu/"
  url "ftp://ftp.soest.hawaii.edu/gmt/gmt-4.5.18-src.tar.bz2"
  mirror "https://fossies.org/linux/misc/GMT/gmt-4.5.18-src.tar.bz2"
  mirror "https://mirrors.ustc.edu.cn/gmt/gmt-4.5.18-src.tar.bz2"
  sha256 "27c30b516c317fed8e44efa84a0262f866521d80cfe76a61bf12952efb522b63"
  revision 4

  bottle do
    sha256 "0322b53160cfc2da08b81dd1f3840ce3ba60fd9aae94e04bff84d1cee14a96ed" => :mojave
    sha256 "847be5f3e0dbbce04b6560c788a7e9bf6ff42354561f7b1559e507718357d205" => :high_sierra
    sha256 "0b9a6cfec7025f3da2fa80beda1ab1f90f7f4c34cae5c4cf36ee702406ff8aa6" => :sierra
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
