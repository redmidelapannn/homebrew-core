class Gmt < Formula
  desc "Tools for manipulating and plotting geographic and Cartesian data"
  homepage "https://www.generic-mapping-tools.org"
  url "https://github.com/GenericMappingTools/gmt/releases/download/6.0.0rc3/gmt-6.0.0rc3-src.tar.xz"
  # url "ftp://ftp.soest.hawaii.edu/gmt/gmt-5.4.5-src.tar.gz"
  # mirror "https://mirrors.ustc.edu.cn/gmt/gmt-5.4.5-src.tar.xz"
  # mirror "https://fossies.org/linux/misc/GMT/gmt-5.4.5-src.tar.xz"
  sha256 "0f84cd2504b6b9945a3a713466972c3876a9561a66524e4278c42471dffdf1c4"

  bottle do
    sha256 "ea95bb9493949cbceea9cc4de71ea999944ba80041661cba74c96880248718fe" => :mojave
    sha256 "8a20d0ac3b4834406f070cc9055f59844064ace9f85a4e67a9d9982e1132d344" => :high_sierra
    sha256 "0b91c5836cb57393f1bc599fa864703ccdbed5f1579f85cb7ce3f224a7d48198" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gdal"
  depends_on "netcdf"
  depends_on "pcre"

  resource "gshhg" do
    url "ftp://ftp.soest.hawaii.edu/gmt/gshhg-gmt-2.3.7.tar.gz"
    mirror "https://mirrors.ustc.edu.cn/gmt/gshhg-gmt-2.3.7.tar.gz"
    mirror "https://fossies.org/linux/misc/GMT/gshhg-gmt-2.3.7.tar.gz"
    sha256 "9bb1a956fca0718c083bef842e625797535a00ce81f175df08b042c2a92cfe7f"
  end

  resource "dcw" do
    url "ftp://ftp.soest.hawaii.edu/gmt/dcw-gmt-1.1.4.tar.gz"
    mirror "https://mirrors.ustc.edu.cn/gmt/dcw-gmt-1.1.4.tar.gz"
    mirror "https://fossies.org/linux/misc/GMT/dcw-gmt-1.1.4.tar.gz"
    sha256 "8d47402abcd7f54a0f711365cd022e4eaea7da324edac83611ca035ea443aad3"
  end

  def install
    (buildpath/"gshhg").install resource("gshhg")
    (buildpath/"dcw").install resource("dcw")

    args = std_cmake_args.concat %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DGMT_DOCDIR=#{share}/doc/gmt
      -DGMT_MANDIR=#{man}
      -DGSHHG_ROOT=#{buildpath}/gshhg
      -DCOPY_GSHHG:BOOL=TRUE
      -DDCW_ROOT=#{buildpath}/dcw
      -DCOPY_DCW:BOOL=TRUE
      -DFFTW3_ROOT=#{Formula["fftw"].opt_prefix}
      -DGDAL_ROOT=#{Formula["gdal"].opt_prefix}
      -DNETCDF_ROOT=#{Formula["netcdf"].opt_prefix}
      -DPCRE_ROOT=#{Formula["pcre"].opt_prefix}
      -DFLOCK:BOOL=TRUE
      -DGMT_INSTALL_MODULE_LINKS:BOOL=TRUE
      -DGMT_INSTALL_TRADITIONAL_FOLDERNAMES:BOOL=FALSE
      -DLICENSE_RESTRICTED:BOOL=FALSE
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/pscoast -R0/360/-70/70 -Jm1.2e-2i -Ba60f30/a30f15 -Dc -G240 -W1/0 -P > test.ps"
    assert_predicate testpath/"test.ps", :exist?
  end
end
