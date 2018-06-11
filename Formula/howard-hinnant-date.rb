class HowardHinnantDate < Formula
  desc "C++ library for date and time operations based on <chrono>"
  homepage "https://github.com/HowardHinnant/date"
  url "https://github.com/HowardHinnant/date/archive/v2.4.1.tar.gz"
  sha256 "98907d243397483bd7ad889bf6c66746db0d7d2a39cc9aacc041834c40b65b98"
  head "https://github.com/HowardHinnant/date.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "fe8522f03e1bf008186f96217c1ff041a3df5c13c8f782500886d9b8bf4720ee" => :high_sierra
    sha256 "6bb86f353173dbafb8a230abaf99712cdff0e97b38e5f7b13325ccbff9601d13" => :sierra
    sha256 "b83ae912b2f6d96f6995e84364c9f31c0cd2aab99566b233e60dca258bd921c4" => :el_capitan
  end

  option "without-string-view", "Disable C++ string view"

  depends_on "cmake" => :build

  needs :cxx11

  def install
    custom_args = ["-DENABLE_DATE_TESTING=OFF", "-DUSE_SYSTEM_TZ_DB=ON", "-DBUILD_SHARED_LIBS=ON"]

    if build.with? "string-view"
      custom_args << "-DDISABLE_STRING_VIEW=OFF"
    else
      custom_args << "-DDISABLE_STRING_VIEW=ON"
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
