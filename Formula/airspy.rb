class Airspy < Formula
  desc "The usemode driver and associated tools for airspy"
  homepage "https://airspy.com/"
  url "https://github.com/airspy/host/archive/v1.0.9.tar.gz"
  sha256 "967ef256596d4527b81f007f77b91caec3e9f5ab148a8fec436a703db85234cc"
  head "https://github.com/airspy/host.git"

  bottle do
    rebuild 1
    sha256 "a703aa280272cff3695ec648f2d33f9e1a3d7f26eaa5e4c36b4bf03155b4a835" => :high_sierra
    sha256 "ebf9ee935003546262d2b80ff1f913bd8c2c905cd1b1be04e83e4b98589329aa" => :sierra
    sha256 "36ff672ee76ddd39d2777d5c48e8b13061fba723dc97919cf4099c2758fe190b" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
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
