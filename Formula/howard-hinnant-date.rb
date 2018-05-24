class HowardHinnantDate < Formula
  desc "C++ library for date and time operations based on <chrono>"
  homepage "https://github.com/HowardHinnant/date"
  url "https://github.com/HowardHinnant/date/archive/v2.4.1.tar.gz"
  sha256 "98907d243397483bd7ad889bf6c66746db0d7d2a39cc9aacc041834c40b65b98"
  head "https://github.com/HowardHinnant/date.git"

  bottle do
    cellar :any
    sha256 "92fa4808e4dcde7540032ce0aac6a0a33e468e654944706ba2661187e2111616" => :high_sierra
    sha256 "f42440908ef92ade61d8b1b3c152355162768b0a5eaca3fcc1ed3deae72f8c17" => :sierra
    sha256 "c3902905c2a51ae0e35fe54b84b00f68d97408f502d83b21f293087d16b9e175" => :el_capitan
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
