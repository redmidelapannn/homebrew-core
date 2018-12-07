class Airspy < Formula
  desc "The usemode driver and associated tools for airspy"
  homepage "https://airspy.com/"
  url "https://github.com/airspy/airspyone_host/archive/v1.0.9.tar.gz"
  sha256 "967ef256596d4527b81f007f77b91caec3e9f5ab148a8fec436a703db85234cc"
  head "https://github.com/airspy/airspyone_host.git"

  bottle do
    rebuild 1
    sha256 "7e5fc4452274881b9e06722f67c27368512b8a31639810d1c1bc63b32714e520" => :mojave
    sha256 "b3e9d0d8489db70c7bfb61f052d4e230777da3d7064b4330ff85ff29791f7e45" => :high_sierra
    sha256 "dbafca00c96d25edab17655135f141adab48bde5f605bc71559220c43e62478e" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    args = std_cmake_args

    libusb = Formula["libusb"]
    args << "-DLIBUSB_INCLUDE_DIR=#{libusb.opt_include}/libusb-1.0"
    args << "-DLIBUSB_LIBRARIES=#{libusb.opt_lib}/libusb-1.0.dylib"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/airspy_lib_version").chomp
  end
end
