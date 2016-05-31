class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/0.10.15.tar.gz"
  sha256 "88c833843b852920e228f7748c703f822770ee6e9595de55bf4b027b12547f06"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    revision 1
    sha256 "11dcafce93dcf050f56cd433346a346d61fddb0a1940aedd7385e5b7b3cd49c9" => :el_capitan
    sha256 "98809e4490f7157a27e107030c7a10bd6686914b3c8172a11bf2726ce3ac172e" => :yosemite
    sha256 "975e2faa734579bc5852d973866d40c5a856f2166c3789c8a3261a4135588884" => :mavericks
  end

  option "with-static", "Build with static linking"
  option "without-http-client", "Don't include the libcurl HTTP client"
  option "with-logging-only", "Only build logging-related SDKs"
  option "with-minimize-size", "Request size optimization"

  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DSTATIC_LINKING=1" if build.with? "static"
    args << "-DNO_HTTP_CLIENT=1" if build.without? "http-client"
    args << "-DBUILD_ONLY=firehose;kinesis" if build.with? "logging-only"
    args << "-DMINIMIZE_SIZE=ON" if build.with? "minimize-size"

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
