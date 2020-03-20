class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.300.tar.gz"
  sha256 "ee3f8df79b3ce727e79831db9cb77d45cd17ecc27fffc4d97d71df16ea8eeebf"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 "d9ec2e461997267a357b7e05cdc49a497b1c6d61c8ce3d9830153a67d1fe6c44" => :catalina
    sha256 "29fe53fbfbeba053a0ec3b35f7c50541374cc85f24485ebd765207ad1a0acf9f" => :high_sierra
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end

    lib.install Dir[lib/"mac/Release/*"].select { |f| File.file? f }
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <aws/core/Version.h>
      #include <iostream>

      int main() {
          std::cout << Aws::Version::GetVersionString() << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core",
           "-o", "test"
    system "./test"
  end
end
