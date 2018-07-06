class Librtlsdr < Formula
  desc "Use Realtek DVT-T dongles as a cheap SDR"
  homepage "https://sdr.osmocom.org/trac/wiki/rtl-sdr"
  url "https://github.com/steve-m/librtlsdr/archive/v0.5.4.tar.gz"
  sha256 "6fd0d298c1a18fc8005b0c2f6199b08bc15e3fb4f4312f551eea2ae269c940c5"
  head "git://git.osmocom.org/rtl-sdr.git", :shallow => false

  bottle do
    cellar :any
    rebuild 1
    sha256 "813c64824db423fe34cb8387412003a83fe71c88a5ca04602b64a898fde328a0" => :high_sierra
    sha256 "17a32ccf1f013334ca875cca3d158bc446062d08a0c2cf90bfcc5bb9e146de00" => :sierra
    sha256 "c092e43a5046a8d564b4db0c34f7b4ea08649d4db37936ca38d0395f6bb40442" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
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
