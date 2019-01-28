class OpencvAT2 < Formula
  desc "Open source computer vision library"
  homepage "https://opencv.org/"
  url "https://github.com/opencv/opencv/archive/2.4.13.7.tar.gz"
  sha256 "192d903588ae2cdceab3d7dc5a5636b023132c8369f184ca89ccec0312ae33d0"
  revision 2

  bottle do
    rebuild 1
    sha256 "198f610ef268b355cc805bf41b9ad084283c1f213b4e9a6a2c333b25ca25e9b7" => :mojave
    sha256 "04925c45aff70f0d2408a4d355cf60fa0f79cfd45074869701ee8da0288e0970" => :high_sierra
    sha256 "f7930915e17d9bd5e85eae0ff99fe84ef77499844363777b9f88f32cbe71f26b" => :sierra
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "eigen"
  depends_on "ffmpeg"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "numpy"
  depends_on "openexr"
  depends_on "python@2" # does not support Python 3

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
      -DBUILD_opencv_python=ON
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
      -DENABLE_SSSE3=ON
    ]

    py_prefix = `python-config --prefix`.chomp
    py_lib = "#{py_prefix}/lib"
    args << "-DPYTHON_LIBRARY=#{py_lib}/libpython2.7.dylib"
    args << "-DPYTHON_INCLUDE_DIR=#{py_prefix}/include/python2.7"

    # Make sure find_program locates system Python
    # https://github.com/Homebrew/homebrew-science/issues/2302
    args << "-DCMAKE_PREFIX_PATH=#{py_prefix}"

    if MacOS.version.requires_sse42?
      args << "-DENABLE_SSE41=ON" << "-DENABLE_SSE42=ON"
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
    output = shell_output("python2.7 -c 'import cv2; print(cv2.__version__)'")
    assert_match version.to_s, output
  end
end
