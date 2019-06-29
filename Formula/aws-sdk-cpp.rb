class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.7.130.tar.gz"
  sha256 "199ec285f47f0473aa071fa048c2bce9ee31a34f482f94627caa8b6704bcbec1"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ae39bf3013cb1150ed800d827b15d5e760176db0eb8f40bea2dffc6064cb54cd" => :mojave
    sha256 "f712d5907f75903d972818a9be2d23094638310e9c11d686e672d9b6e7321f75" => :high_sierra
    sha256 "9f14fc29c777e5517a00fe9b9f09f9dbea3b8de029013e23bcef9fcbfd1cd4fc" => :sierra
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
