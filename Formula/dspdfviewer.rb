class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "https://dspdfviewer.danny-edel.de/"
  url "https://github.com/dannyedel/dspdfviewer/archive/v1.15.1.tar.gz"
  sha256 "c5b6f8c93d732e65a27810286d49a4b1c6f777d725e26a207b14f6b792307b03"
  revision 5

  head "https://github.com/dannyedel/dspdfviewer.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "24c8964a0c10c3c3c017e789b1c68bce1f02efb56c54e2437092a9a8e66296dc" => :high_sierra
    sha256 "affd07bab88b1850b28eade156d72e0fee7204d5873dd8d03fce3f15152fac2b" => :sierra
    sha256 "18a96f1d4fe1aa16138e5ca5cf2a0e172c5e34990c424ee789863e937a78e034" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "poppler" => "with-qt"
  depends_on "qt"

  def install
    args = std_cmake_args
    args << "-DUsePrerenderedPDF=ON"
    args << "-DRunDualScreenTests=OFF"
    args << "-DUseQtFive=ON"
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system bin/"dspdfviewer", "--help"
  end
end
