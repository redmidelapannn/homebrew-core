class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and  BUFR 3/4 formats"
  homepage "https://software.ecmwf.int/wiki/display/ECC/ecCodes+Home"
  url "https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.7.3-Source.tar.gz"
  sha256 "6fab143dbb34604bb2e04d10143855c0906b00411c1713fd7ff5c35519b871db"

  bottle do
    rebuild 1
    sha256 "2af64410f2ad729dd0bdea17013e3c7e90b49e299d23b6b4d47af1eca756a73e" => :high_sierra
    sha256 "1ed162f081af2af1da9e186d1b6a6116d62b5edce651f836b726bfa38bf10493" => :sierra
    sha256 "aa560b163b8ccd36139fcdcf2e03bf91ba17b5a102ac386b4b3b99e5ecddb0de" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "jasper"
  depends_on "libpng"
  depends_on "numpy"

  conflicts_with "grib-api",
    :because => "eccodes and grib-api install the same binaries."

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
