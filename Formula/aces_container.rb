class AcesContainer < Formula
  desc "Reference implementation of SMPTE ST2065-4"
  homepage "https://github.com/ampas/aces_container"
  url "https://github.com/ampas/aces_container/archive/v1.0.2.tar.gz"
  sha256 "cbbba395d2425251263e4ae05c4829319a3e399a0aee70df2eb9efb6a8afdbae"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b4b38bcc7155b0641bf6d3d2bfad8d4a7889d6b745281f6e96ad99bae1792a7f" => :high_sierra
    sha256 "3e0602ee29665f251e9c9e5a6fdbb744c5e21d5ce647e22ffba88cf0f059bdc2" => :sierra
    sha256 "a7fff22d95b036bf08f8be1dfc7b7dc9d458c136b954e8c987691fa3db608b09" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "aces/aces_Writer.h"

      int main()
      {
          aces_Writer x;
          return 0;
      }
    EOS
    system ENV.cxx, "-L#{lib}", "-lacescontainer", "test.cpp", "-o", "test"
    system "./test"
  end
end
