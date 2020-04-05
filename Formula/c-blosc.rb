class CBlosc < Formula
  desc "Blocking, shuffling and loss-less compression library"
  homepage "https://blosc.org/"
  url "https://github.com/Blosc/c-blosc/archive/v1.18.1.tar.gz"
  sha256 "18730e3d1139aadf4002759ef83c8327509a9fca140661deb1d050aebba35afb"

  bottle do
    cellar :any
    sha256 "c46daac1d7825a11898af51b4cd164d7950c9676b6a26ef698793c9850d0c2a7" => :catalina
    sha256 "664212e137fdee165a38f085a09f4d037e72ab44e728083e2ee45995928ab838" => :mojave
    sha256 "f2fe09103011af04367888bbc33da0cb3e086e7a23c9eb1347a2426d75414fd2" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <blosc.h>
      int main() {
        blosc_init();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lblosc", "-o", "test"
    system "./test"
  end
end
