class Cpputest < Formula
  desc "C /C++ based unit xUnit test framework"
  homepage "https://www.cpputest.org/"
  url "https://github.com/cpputest/cpputest/releases/download/v3.8/cpputest-3.8.tar.gz"
  sha256 "c81dccc5a1bfc7fc6511590c0a61def5f78e3fb19cb8e1f889d8d3395a476456"
  head "https://github.com/cpputest/cpputest.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2d26ce3aa53a859dc32d5632c570cb7c7db7af0fda16bc4d2fa80c548e2e4378" => :high_sierra
    sha256 "1990d92d576442fd8643fa279e7c9c5704978914823e4a226b60a772dd5fae1a" => :sierra
    sha256 "5983d222c2fbf4346d0e0599e5c9ffdf595ce0e40032304e5b9b465a4da025c2" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    cd "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "CppUTest/CommandLineTestRunner.h"
      int main(int ac, char** av)
      {
        return CommandLineTestRunner::RunAllTests(ac, av);
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lCppUTest", "-o", "test"
    assert_match /OK \(0 tests/, shell_output("./test")
  end
end
