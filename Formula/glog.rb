class Glog < Formula
  desc "Application-level logging library"
  homepage "https://github.com/google/glog"
  url "https://github.com/google/glog/archive/v0.4.0.tar.gz"
  sha256 "f28359aeba12f30d73d9e4711ef356dc842886968112162bc73002645139c39c"
  head "https://github.com/google/glog.git"
  revision 4

  bottle do
    cellar :any
    sha256 "9059bf668a7b31db281ce007cb6a437d904551a485c8fe09a70ba755d0e92830" => :mojave
    sha256 "8ad58e62fdc6eaf887be802267cf7d6d94e3c6790a86c2a023185f565c70bd63" => :high_sierra
    sha256 "63c529987cf1dfbeaf136b149d47cd0a210ce344bc7bf21b7c2036077cb06886" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "gflags"

  def install
    mkdir "cmake-build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "make", "install"
      system "cmake", "..", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
      system "make", "install"
    end

    # Upstream PR from 30 Aug 2017 "Produce pkg-config file under cmake"
    # See https://github.com/google/glog/pull/239
    (lib/"pkgconfig/libglog.pc").write <<~EOS
      prefix=#{prefix}
      exec_prefix=${prefix}
      libdir=${exec_prefix}/lib
      includedir=${prefix}/include

      Name: libglog
      Description: Google Log (glog) C++ logging framework
      Version: #{stable.version}
      Libs: -L${libdir} -lglog
      Cflags: -I${includedir}
    EOS
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <glog/logging.h>
      #include <iostream>
      #include <memory>
      int main(int argc, char* argv[])
      {
        google::InitGoogleLogging(argv[0]);
        LOG(INFO) << "test";
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}",
                    "-lglog", "-o", "test"
    system "./test"
  end
end
