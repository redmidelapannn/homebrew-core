class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http://dlib.net/"
  url "http://dlib.net/files/dlib-19.16.tar.bz2"
  sha256 "37308406c2b1459a70f21ec2fd7bdc922277659534c708323cb28d6e8e4764a8"
  revision 1
  head "https://github.com/davisking/dlib.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "dec04d3f47e46c9b701944fc6f5ab15adbcf80c6e8b0c2cde14cfe1667a683cc" => :mojave
    sha256 "5f7dd8740896a1bbe520f34b049d46f54b18954a5980f085a6c1e9974c678cc3" => :high_sierra
    sha256 "60a3861e0ea182fe6cbc21b04f5a13e7504f3b944b555188bda0a98295e5ef81" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on :macos => :el_capitan # needs thread-local storage
  depends_on "openblas"

  def install
    ENV.cxx11

    args = std_cmake_args + %W[
      -DDLIB_USE_BLAS=ON
      -DDLIB_USE_LAPACK=ON
      -Dcblas_lib=#{Formula["openblas"].opt_lib}/libopenblas.dylib
      -Dlapack_lib=#{Formula["openblas"].opt_lib}/libopenblas.dylib
      -DDLIB_NO_GUI_SUPPORT=ON
      -DUSE_SSE2_INSTRUCTIONS=ON
    ]

    if MacOS.version.requires_sse4?
      args << "-DUSE_SSE4_INSTRUCTIONS=ON"
    end

    mkdir "dlib/build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <dlib/logger.h>
      dlib::logger dlog("example");
      int main() {
        dlog.set_level(dlib::LALL);
        dlog << dlib::LINFO << "The answer is " << 42;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-ldlib"
    assert_match /INFO.*example: The answer is 42/, shell_output("./test")
  end
end
