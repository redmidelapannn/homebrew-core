class Librtlsdr < Formula
  desc "Use Realtek DVB-T dongles as a cheap SDR"
  homepage "https://osmocom.org/projects/rtl-sdr/wiki"
  url "https://github.com/steve-m/librtlsdr/archive/0.6.0.tar.gz"
  sha256 "80a5155f3505bca8f1b808f8414d7dcd7c459b662a1cde84d3a2629a6e72ae55"
  head "https://git.osmocom.org/rtl-sdr", :using => :git, :shallow => false

  bottle do
    cellar :any
    rebuild 1
    sha256 "130562e43aa3610d828ca5eaf2184efaed0523e18963489be272c49f978d1c36" => :mojave
    sha256 "32f29264006d378d71e858145c57e81e984feceacd78a7ffa80b8105d764f07b" => :high_sierra
    sha256 "8ec886fa70493112e80b061cc6a46aa5a77308fb4803d91a7285fe4da26bcf57" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "rtl-sdr.h"

      int main()
      {
        rtlsdr_get_device_count();
        return 0;
      }
    EOS
    system ENV.cc, "-L#{lib}", "-lrtlsdr", "test.c", "-o", "test"
    system "./test"
  end
end
