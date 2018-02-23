class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "https://ompl.kavrakilab.org/"
  url "https://bitbucket.org/ompl/ompl/downloads/ompl-1.3.2-Source.tar.gz"
  sha256 "c33e04089f7513780f4e87b6507182d5224cd604b0a4f4546ebb9f4a124c8f49"

  bottle do
    rebuild 1
    sha256 "d8023f9e748812e2f0455df62343f5d6dfa235b3ea67be6147bd282334645380" => :high_sierra
    sha256 "3f367eec2f8fc3f9100cffcb3c21026f42537620b3752f90832cd465e1943bae" => :sierra
    sha256 "d000abbc7881dec06f63162a57d165dfa43944e0a8d947fa27a28b32cf86f296" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "eigen" => :optional
  depends_on "ode" => :optional

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ompl/base/spaces/RealVectorBounds.h>
      #include <cassert>
      int main(int argc, char *argv[]) {
        ompl::base::RealVectorBounds bounds(3);
        bounds.setLow(0);
        bounds.setHigh(5);
        assert(bounds.getVolume() == 5 * 5 * 5);
      }
    EOS

    system ENV.cc, "test.cpp", "-L#{lib}", "-lompl", "-lstdc++", "-o", "test"
    system "./test"
  end
end
