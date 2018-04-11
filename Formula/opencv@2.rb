class OpencvAT2 < Formula
  desc "Open source computer vision library"
  homepage "https://opencv.org/"
  url "https://github.com/opencv/opencv/archive/2.4.13.6.tar.gz"
  sha256 "6ecbeea11f68356b748e35f758f4406067d3a2f6339e4582c63373fa6c3f5a72"
  revision 1

  bottle do
    sha256 "5fb0cfe84d8aec4131deaed377897e9e778cc33714bd665715ec7c25b60d3e12" => :high_sierra
    sha256 "94a48e1f6c9ea84c6f47b60d9391fb09ebfa1604b5103d96b562a5b1ddb1c2d1" => :sierra
    sha256 "4a9141d8d639914985bf91d65800f195be70125e17940ad7060e76ccaeaa38d7" => :el_capitan
  end

  keg_only :versioned_formula

  option "without-python@2", "Build without python2 support"

  deprecated_option "without-python" => "without-python@2"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "eigen"
  depends_on "ffmpeg"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr"
  depends_on "python@2" => :recommended
  depends_on "numpy" if build.with? "python@2"

  def install
    jpeg = Formula["jpeg"]

    args = std_cmake_args + %W[
      -DCMAKE_OSX_DEPLOYMENT_TARGET=
      -DBUILD_JASPER=OFF
      -DBUILD_JPEG=OFF
      -DBUILD_OPENEXR=OFF
      -DBUILD_PERF_TESTS=OFF
      -DBUILD_PNG=OFF
      -DBUILD_TESTS=OFF
      -DBUILD_TIFF=OFF
      -DBUILD_ZLIB=OFF
      -DBUILD_opencv_java=OFF
      -DWITH_CUDA=OFF
      -DWITH_EIGEN=ON
      -DWITH_FFMPEG=ON
      -DWITH_GSTREAMER=OFF
      -DWITH_JASPER=OFF
      -DWITH_OPENEXR=ON
      -DWITH_OPENGL=ON
      -DWITH_TBB=OFF
      -DJPEG_INCLUDE_DIR=#{jpeg.opt_include}
      -DJPEG_LIBRARY=#{jpeg.opt_lib}/libjpeg.dylib
    ]

    args << "-DBUILD_opencv_python=" + (build.with?("python@2") ? "ON" : "OFF")

    if build.with? "python@2"
      py_prefix = `python-config --prefix`.chomp
      py_lib = "#{py_prefix}/lib"
      args << "-DPYTHON_LIBRARY=#{py_lib}/libpython2.7.dylib"
      args << "-DPYTHON_INCLUDE_DIR=#{py_prefix}/include/python2.7"

      # Make sure find_program locates system Python
      # https://github.com/Homebrew/homebrew-science/issues/2302
      args << "-DCMAKE_PREFIX_PATH=#{py_prefix}"
    end

    if ENV.compiler == :clang && !build.bottle?
      args << "-DENABLE_SSSE3=ON" if Hardware::CPU.ssse3?
      args << "-DENABLE_SSE41=ON" if Hardware::CPU.sse4?
      args << "-DENABLE_SSE42=ON" if Hardware::CPU.sse4_2?
      args << "-DENABLE_AVX=ON" if Hardware::CPU.avx?
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <opencv/cv.h>
      #include <iostream>
      int main() {
        std::cout << CV_VERSION << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-o", "test"
    assert_equal version.to_s, shell_output("./test").strip

    ENV["PYTHONPATH"] = lib/"python2.7/site-packages"
    assert_match version.to_s,
                 shell_output("python2.7 -c 'import cv2; print(cv2.__version__)'")
  end
end
