class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/mdadams/jasper/archive/version-2.0.14.tar.gz"
  sha256 "85266eea728f8b14365db9eaf1edc7be4c348704e562bb05095b9a077cf1a97b"
  revision 1

  bottle do
    sha256 "a53b8fa354c134cf43ce750adda3f438a0fd880428d858762c3f545548153e90" => :high_sierra
    sha256 "4b2b27abf01c3ef8a3b325f9cb9807bb9f4a0babc0679a7557ef93b3e91e65a3" => :sierra
    sha256 "bc31a89bfbf7c61e822f6f09c577e766a98b173333b315c82fb071a05e155bb6" => :el_capitan
  end

  option "with-large-image-support", "Allows handling inputs with more than 67108864 samples (Allows 536870912 samples)."

  depends_on "cmake" => :build
  depends_on "jpeg"

  def install
    if build.with?("large-image-support")
      inreplace "src/libjasper/include/jasper/jas_config.h.in", "(64 * ((size_t) 1048576))", "(512 * ((size_t) 1048576))"
    end
    mkdir "build" do
      # Make sure macOS's GLUT.framework is used, not XQuartz or freeglut
      # Reported to CMake upstream 4 Apr 2016 https://gitlab.kitware.com/cmake/cmake/issues/16045
      glut_lib = "#{MacOS.sdk_path}/System/Library/Frameworks/GLUT.framework"
      system "cmake", "..", "-DGLUT_glut_LIBRARY=#{glut_lib}", *std_cmake_args
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    system bin/"jasper", "--input", test_fixtures("test.jpg"),
                         "--output", "test.bmp"
    assert_predicate testpath/"test.bmp", :exist?
  end
end

