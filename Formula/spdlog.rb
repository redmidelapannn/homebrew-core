class Spdlog < Formula
  desc "Super fast C++ logging library"
  homepage "https://github.com/gabime/spdlog"
  url "https://github.com/gabime/spdlog/archive/v1.0.0.tar.gz"
  sha256 "90d5365121bcd2c41ce94dfe6a460e89507a2dfef6133fe5fad5bb35ac4ef0a1"
  head "https://github.com/gabime/spdlog.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d628f82476a465fc207532d8595608a6420ea79ad4749ee88cc605bc95a07aa1" => :high_sierra
    sha256 "d628f82476a465fc207532d8595608a6420ea79ad4749ee88cc605bc95a07aa1" => :sierra
    sha256 "d628f82476a465fc207532d8595608a6420ea79ad4749ee88cc605bc95a07aa1" => :el_capitan
  end

  depends_on "cmake" => :build

  needs :cxx11

  def install
    ENV.cxx11

    mkdir "spdlog-build" do
      args = std_cmake_args
      args << "-Dpkg_config_libdir=#{lib}" << ".."
      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "spdlog/spdlog.h"
      #include <iostream>
      #include <memory>
      int main()
      {
        auto console = spdlog::stdout_logger_mt("console");
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-o", "test"
    system "./test"
  end
end
