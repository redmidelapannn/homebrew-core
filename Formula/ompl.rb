class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "http://ompl.kavrakilab.org"
  url "https://bitbucket.org/ompl/ompl/downloads/ompl-1.1.0-Source.tar.gz"
  sha256 "4d141ad3aa322c65ee7ecfa90017a44a8114955316e159b635fae5b5e7db74f8"
  revision 1

  bottle do
    sha256 "b7160688bb285f6ec641222585f2d9dfb2e0e77e576c3ebe389075808e44e8ac" => :sierra
    sha256 "9031ee14a558a69d71b4d77beb7574e2a5e5a201a610c07f4df84c212deaf577" => :el_capitan
    sha256 "b09b249dbd1b095014bf38ac20599b0d7c402858cc5ed90979679b2d4b6f9cda" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "boost@1.61"
  depends_on "eigen" => :optional
  depends_on "ode" => :optional

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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
