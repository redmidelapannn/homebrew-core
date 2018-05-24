class HowardHinnantDate < Formula
  desc "C++ library for date and time operations based on <chrono>"
  homepage "https://github.com/HowardHinnant/date"
  url "https://github.com/HowardHinnant/date/archive/v2.4.1.tar.gz"
  sha256 "98907d243397483bd7ad889bf6c66746db0d7d2a39cc9aacc041834c40b65b98"
  head "https://github.com/HowardHinnant/date.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a50e2997cf90996d69cb4c68d782384af271a9e3a4ef061b8b99db122d3d4f77" => :high_sierra
    sha256 "9ab344753667ab659004f01a3180763b3a73a1c881e23e50ee33264acd0fe2c3" => :el_capitan
  end

  option "with-static", "Build the static library instead of the dynamic version"

  depends_on "cmake" => :build

  needs :cxx11

  def install
    custom_args = ["-DENABLE_DATE_TESTING=OFF", "-DUSE_SYSTEM_TZ_DB=ON"]

    if build.with? "static"
      custom_args << "-DBUILD_SHARED_LIBS=OFF"
    else
      custom_args << "-DBUILD_SHARED_LIBS=ON"
    end

    system "cmake", ".", *std_cmake_args, *custom_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "date/tz.h"
      #include <iostream>

      int main() {
        auto t = date::make_zoned(date::current_zone(), std::chrono::system_clock::now());
        std::cout << t << std::endl;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++1y", "-ltz", "-o", "test"
    system "./test"
  end
end
