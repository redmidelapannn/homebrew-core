class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/mdadams/jasper/archive/version-2.0.12.tar.gz"
  sha256 "f0bcc1c4de5fab199f2e792acf269eb34d54689777c305d80e2498788f9f204b"

  bottle do
    rebuild 1
    sha256 "9dbd3e8946fa6168bc9e8361f2be2c992d2860e2ee9f1b501e6ad9e875c64c48" => :sierra
    sha256 "7cd162027f014a69c96afe37b426a0a6ea4aaa78ad08e147dc6dc03ffca54414" => :el_capitan
    sha256 "4dd89722227b0c9456a118b2f4b68bd3998d633ecfa3971cd3c3b80c99099af9" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "jpeg"

  def install
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
