class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.120.tar.gz"
  sha256 "bd347ad071e98e616898297702d33e33ebaeb8e5d42f95f603f369137903086c"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "e21b788aefa0c47e93d229525112f2a3eafb6bc8190664881e42a9b6a2204b56" => :sierra
    sha256 "3a0d9f6e466a334ff493b4a733a1f4b3b69037e9ac6f7fdafeaf7c9e3996e7ac" => :el_capitan
    sha256 "fc8f0f94d4c1e38b08ff9ec884b69eb3bad6e4cefcff23adeb8a681c98e945ae" => :yosemite
  end

  option "with-static", "Build with static linking"
  option "without-http-client", "Don't include the libcurl HTTP client"

  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DSTATIC_LINKING=1" if build.with? "static"
    args << "-DNO_HTTP_CLIENT=1" if build.without? "http-client"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

    lib.install Dir[lib/"mac/Release/*"].select { |f| File.file? f }
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <aws/core/Version.h>
      #include <iostream>

      int main() {
          std::cout << Aws::Version::GetVersionString() << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-laws-cpp-sdk-core"
    system "./test"
  end
end
