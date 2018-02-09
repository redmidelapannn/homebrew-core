class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/googlei18n/libphonenumber"
  url "https://github.com/googlei18n/libphonenumber/archive/v8.8.11.tar.gz"
  sha256 "7c040ae7685788dae6390ee6491efff6701fa7a605ff9b5925be895641530bed"

  bottle do
    cellar :any
    sha256 "1dfd83226ab0eed49b38ac52bc8465706c88a02ade98d9cb50e4458aad1e7acc" => :high_sierra
    sha256 "5bf70fd20a6584c1f475000bffb7cba7a76d8c43ed86f7a642e5aa27c29d3dd2" => :sierra
    sha256 "fa3e59d866162ecc13dc4ed17ac1bea37df9123543e26dacd91276751c9ed429" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on :java => "1.7+"
  depends_on "icu4c"
  depends_on "protobuf"
  depends_on "boost"
  depends_on "re2"

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.8.0.tar.gz"
    sha256 "58a6f4277ca2bc8565222b3bbd58a177609e9c488e8a72649359ba51450db7d8"
  end

  needs :cxx11

  # Upstream issue from 2 Dec 2017 "Libraries getting installed in lib64 by default"
  # See https://github.com/googlei18n/libphonenumber/issues/2044
  patch do
    url "https://github.com/googlei18n/libphonenumber/commit/8dcd3f924.patch?full_index=1"
    sha256 "1da8e0e7a476d1cfbf32d14016c1a86e5fc85ae928aa031b55fa35ec912f6e83"
  end

  def install
    ENV.cxx11
    (buildpath/"gtest").install resource("gtest")
    system "cmake", "cpp", "-DGTEST_SOURCE_DIR=gtest/googletest",
                           "-DGTEST_INCLUDE_DIR=gtest/googletest/include",
                           *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <phonenumbers/phonenumberutil.h>
      #include <phonenumbers/phonenumber.pb.h>
      #include <iostream>
      #include <string>

      using namespace i18n::phonenumbers;

      int main() {
        PhoneNumberUtil *phone_util_ = PhoneNumberUtil::GetInstance();
        PhoneNumber test_number;
        string formatted_number;
        test_number.set_country_code(1);
        test_number.set_national_number(6502530000ULL);
        phone_util_->Format(test_number, PhoneNumberUtil::E164, &formatted_number);
        if (formatted_number == "+16502530000") {
          return 0;
        } else {
          return 1;
        }
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lphonenumber", "-o", "test"
    system "./test"
  end
end
