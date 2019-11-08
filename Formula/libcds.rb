class Libcds < Formula
  desc "C++ library of Concurrent Data Structures"
  homepage "https://libcds.sourceforge.io/doc/cds-api/index.html"
  url "https://github.com/khizmax/libcds/archive/v2.3.3.tar.gz"
  sha256 "f090380ecd6b63a3c2b2f0bdb27260de2ccb22486ef7f47cc1175b70c6e4e388"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4673ada5c2552d2e3b78e6f6f0bd59a9b2deffd4704031423fecdace4de09cfc" => :catalina
    sha256 "324421c48a916fcfed8e3efefad8d3af536be9490948c3a5536981cc813fa2ef" => :mojave
    sha256 "cc9999aef57d9cc746d4929f096a2db0cb8e2d22b75c9e9699a0c51e2b1bd2ae" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cds/init.h>
      int main() {
        cds::Initialize();
        cds::threading::Manager::attachThread();
        cds::Terminate();
        return 0;
      }
    EOS
    system ENV.cxx, "-o", "test", "test.cpp", "-L#{lib}64", "-lcds", "-std=c++11"
    system "./test"
  end
end
