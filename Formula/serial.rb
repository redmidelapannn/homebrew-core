class Serial < Formula
  desc "Cross-platform, Serial Port library written in C++"
  homepage "https://gitlab.com/johnbarton/serial"
  url "https://gitlab.com/johnbarton/serial/-/archive/1.3.2/serial-1.3.2.tar.gz"
  sha256 "381ed4e4b76b414232b89ae044e3d6c1b6c2e2c99fdbea2625ce9888089fee72"
  bottle do
    sha256 "79d0a6fe904c8c2b5492602eac8c357781996791f8ae1ac5a4b72255b64b2dfa" => :mojave
    sha256 "27bb27ba066cdf9819952e6291da9e9ad33887d7510d8d04159ba8940ef67940" => :high_sierra
    sha256 "93d78117a6453ff9538a037d7cfaf89db44376e47ed01c3b20fd3c4f57575b42" => :sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <serial/serial.h>
      int main(int argc, char **argv) {
        auto port = new serial::Serial();
        delete(port);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.c", "-L#{lib}", "-lserial", "-o", "test"
    system "./test"
  end
end
