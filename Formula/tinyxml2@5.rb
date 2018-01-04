class Tinyxml2AT5 < Formula
  desc "Improved tinyxml (in memory efficiency and size)"
  homepage "http://grinninglizard.com/tinyxml2"
  url "https://github.com/leethomason/tinyxml2/archive/5.0.1.tar.gz"
  sha256 "cd33f70a856b681506e3650f9f5f5e5e6c7232da7fa3cfc4e8f56fe7b77dd735"
  head "https://github.com/leethomason/tinyxml2.git"

  bottle do
    cellar :any
    sha256 "37e49697f3c04886e37ae703f85d4765e30c8b4aeaab4b1e05fe909a6bf8d32a" => :high_sierra
    sha256 "47bd565bea06095687147fa2cdc6ff394850cf4472a00fd540d0d5805e702c60" => :sierra
    sha256 "d7da2f5c9b3709f5a98a0462093845039f466aa33104c132f0cda21f033b6316" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <tinyxml2.h>
      int main() {
        tinyxml2::XMLDocument doc (false);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-ltinyxml2", "-o", "test"
    system "./test"
  end
end
