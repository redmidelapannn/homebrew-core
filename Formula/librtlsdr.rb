class Librtlsdr < Formula
  desc "Use Realtek DVT-T dongles as a cheap SDR"
  homepage "https://osmocom.org/projects/rtl-sdr/wiki"
  url "https://github.com/steve-m/librtlsdr/archive/0.6.0.tar.gz"
  sha256 "80a5155f3505bca8f1b808f8414d7dcd7c459b662a1cde84d3a2629a6e72ae55"
  head "https://git.osmocom.org/rtl-sdr", :using => :git, :shallow => false

  bottle do
    cellar :any
    rebuild 1
    sha256 "24b27e2274146b237729b6809a5feb2a4aa70646dae972250b28e9686436c181" => :mojave
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
