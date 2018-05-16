class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and  BUFR 3/4 formats"
  homepage "https://software.ecmwf.int/wiki/display/ECC/ecCodes+Home"
  url "https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.7.3-Source.tar.gz"
  sha256 "6fab143dbb34604bb2e04d10143855c0906b00411c1713fd7ff5c35519b871db"

  bottle do
    rebuild 1
    sha256 "627622020c4701e7e49a82ff76a64c7db456c01292ff5e8e33aec7663327a7b1" => :high_sierra
    sha256 "2502ba94dd822ac4d8ae69de3ad5a04213b625a39fe622c858235e021ae8a3fb" => :sierra
    sha256 "73ab2ab3d63a09635bfbf05ab6c6bb8752a966b7fd901e2d11ba48e94a3b1ff8" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "jasper"
  depends_on "libpng"
  depends_on "numpy"

  conflicts_with "grib-api", :because => "both install grib_api.h"

  def install
    inreplace "CMakeLists.txt", "find_package( OpenJPEG )", ""

    mkdir "build" do
      system "cmake", "..", "-DENABLE_NETCDF=OFF", "-DENABLE_PNG=ON", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    grib_samples_path = shell_output("#{bin}/codes_info -s").strip
    assert_match "packingType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB1.tmpl")
    assert_match "gridType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB2.tmpl")
  end
end
