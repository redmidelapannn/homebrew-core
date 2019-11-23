class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.14.1-Source.tar.gz"
  sha256 "16da742691c0ac81ccc378ae3f97311ef0dfdc82505aa4c652eb773e911cc9d6"

  bottle do
    rebuild 1
    sha256 "4e4bca356af87e28c9d53e54c8fa049ac2cde76f90cb3b98e500b6223de4c059" => :catalina
    sha256 "e1d68ecd9b013c8d439cc030bf1e94b97fabb2f65dc7c598cc5bfd95b57a1b31" => :mojave
    sha256 "98bdbdbd943dc31387891f9777fe1b73b1d6954f4a33bcccb9dfab402abf7687" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "jasper"
  depends_on "libpng"
  depends_on "netcdf"

  def install
    inreplace "CMakeLists.txt", "find_package( OpenJPEG )", ""

    mkdir "build" do
      system "cmake", "..", "-DENABLE_NETCDF=ON", "-DENABLE_PNG=ON",
                            "-DENABLE_PYTHON=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    grib_samples_path = shell_output("#{bin}/codes_info -s").strip
    assert_match "packingType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB1.tmpl")
    assert_match "gridType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB2.tmpl")
  end
end
