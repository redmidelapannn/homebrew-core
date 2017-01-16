class Grt < Formula
  desc "The Gesture Recognition Toolkit for real-time machine learning"
  homepage "http://nickgillian.com/grt/"
  url "https://github.com/nickgillian/grt/archive/v0.0.1.tar.gz"
  sha256 "56f90a9ffa8b2bf4e5831d39f9e1912879cf032efa667a5237b57f68800a2dda"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3820ec5717078ac63d506bcf66adc9283a9b515a44c7e6e12f830ed2e0fa387c" => :sierra
    sha256 "5e1dc7ef09a152e3a86450b332ecaa49c1cb72eed79f98c13627628bff948e72" => :el_capitan
    sha256 "f16cbe42515d2a6d6d5eabbd855b569bcbef58578b54c3f02202a7288346919d" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    cd "build"
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <GRT/GRT.h>
      int main() {
        GRT::GestureRecognitionPipeline pipeline;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lgrt", "-o", "test"
    system "./test"
  end
end
