class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://github.com/mdadams/jasper/archive/version-2.0.14.tar.gz"
  sha256 "85266eea728f8b14365db9eaf1edc7be4c348704e562bb05095b9a077cf1a97b"

  bottle do
    rebuild 1
    sha256 "e4762e5f334b02c45cdfc92fdcbed4632acbd73595943b0c47fb4dc52544e00b" => :high_sierra
    sha256 "96c248deef3490b5e9bb894148d8f589b90289e240527e01fd7281e730e75697" => :sierra
    sha256 "c390b2b1eaa9820f637c2cf14b7dffd05e3204b66b89993e27d2310733ae57f9" => :el_capitan
  end

  option "without-doc", "Disable the building of the documentation (which requires LaTeX)"

  depends_on "cmake" => :build
  depends_on "jpeg"

  def install
    cmake_args = std_cmake_args

    if build.without? "doc"
      cmake_args << "-DJAS_ENABLE_DOC=false"
    end

    mkdir "build" do
      # Make sure macOS's GLUT.framework is used, not XQuartz or freeglut
      # Reported to CMake upstream 4 Apr 2016 https://gitlab.kitware.com/cmake/cmake/issues/16045
      glut_lib = "#{MacOS.sdk_path}/System/Library/Frameworks/GLUT.framework"
      system "cmake", "..", "-DGLUT_glut_LIBRARY=#{glut_lib}", *cmake_args
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
