class OpencvAT2 < Formula
  desc "Open source computer vision library"
  homepage "https://opencv.org/"
  url "https://github.com/opencv/opencv/archive/2.4.13.7.tar.gz"
  sha256 "192d903588ae2cdceab3d7dc5a5636b023132c8369f184ca89ccec0312ae33d0"
  revision 8

  bottle do
    sha256 "858d38618c39ee03956b6a21bd04e9050109e5086fef259b31d5f62d81ce0d9a" => :catalina
    sha256 "acfd96b9667a82e0058ba26725608ea63fc35f22ea3e777cf63135f0ae4787c3" => :mojave
    sha256 "efcc54bb7a9fed86c80beb6c902a50f0040455559100f4daab3dbb571a1703c8" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "eigen"
  depends_on "ffmpeg"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "numpy@1.16"
  depends_on "openexr"
  uses_from_macos "python@2"

  def install
    ENV.cxx11
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
