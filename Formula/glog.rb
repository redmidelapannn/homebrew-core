class Glog < Formula
  desc "Application-level logging library"
  homepage "https://github.com/google/glog"
  url "https://github.com/google/glog/archive/v0.3.5.tar.gz"
  sha256 "7580e408a2c0b5a89ca214739978ce6ff480b5e7d8d7698a2aa92fadc484d1e0"
  revision 1
  head "https://github.com/google/glog.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b505520586c154c2ac851928b85f6c83f8e009806141a512d0f9197a09c3a50c" => :high_sierra
    sha256 "95ae771eb9ff5d18d3d56a50a8674dadeef2a4dd89241d67359db534e9513717" => :sierra
    sha256 "dd95a4be662c2b96e5df7a725bfbcf7d02c5d8d481ca8ccd6b0144ffed983d73" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "gflags"

  def install
    mkdir "glog-build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <glog/logging.h>
      #include <iostream>
      #include <memory>
      int main(int argc, char* argv[])
      {
        google::InitGoogleLogging(argv[0]);
        LOG(INFO) << "test";
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}", "-lglog", "-lgflags", "-o", "test"
    system "./test"
  end
end
