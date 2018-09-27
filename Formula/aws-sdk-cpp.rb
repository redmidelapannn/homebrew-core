class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.5.10.tar.gz"
  sha256 "b10d4d643cf88fd44d6ac5f36a0c473105cc8bfdc7ea1a8d9b67c29efb875885"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "94d289a6a5f029606172b9ab56c23b6a2e37392fe5da12f5240304d6ab404f69" => :mojave
    sha256 "422e57947ad38f4d237addf3c9d51b740417100d546d23135f59b4723852f0db" => :high_sierra
    sha256 "ba2ff98e86f557b2af591c478269827953672a473a43b61cad804473e73c6131" => :sierra
  end

  option "with-static", "Build with static linking"

  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DSTATIC_LINKING=1" if build.with? "static"

    mkdir "build" do
      system "cmake", "..", *args
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
