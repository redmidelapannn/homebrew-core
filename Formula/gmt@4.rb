class GmtAT4 < Formula
  desc "Manipulation of geographic and Cartesian data sets"
  homepage "https://gmt.soest.hawaii.edu/"
  url "ftp://ftp.soest.hawaii.edu/gmt/gmt-4.5.17-src.tar.bz2"
  mirror "https://fossies.org/linux/misc/GMT/gmt-4.5.17-src.tar.bz2"
  mirror "https://mirrors.ustc.edu.cn/gmt/gmt-4.5.17-src.tar.bz2"
  sha256 "d69c4e2075f16fb7c153ba77429a7b60e45c44583ebefd7aae63ae05439d1d41"

  bottle do
    rebuild 1
    sha256 "87829c8c443e3157181a4bf4521b0c29ad6684ffa196ccb62691be31c282c30f" => :high_sierra
    sha256 "6cd6841453d967f088df220c8dbd677a72b1f7124dc70f83995681cc44fa6213" => :sierra
    sha256 "f111cda6ba6ca3bcbdf1a6e6f11872edd8545d4bf99e0d367f76a715d8fbf914" => :el_capitan
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
