class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "http://dspdfviewer.danny-edel.de"
  url "https://github.com/dannyedel/dspdfviewer/archive/v1.15.tar.gz"
  sha256 "19986053ac4a60e086a9edd78281f1e422a64efef29e3c6604386419e9420686"
  revision 1

  head "https://github.com/dannyedel/dspdfviewer.git"

  bottle do
    cellar :any
    sha256 "6dd26aeaab7ed14de2157cfc3da48603ee4002034e93f78067813dc637a08602" => :el_capitan
    sha256 "815cab99ca7f359efe73babe46efa32e05910cc9b93adb28abb70341a671567d" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost@1.61"
  depends_on "poppler" => "with-qt5"

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
    assert_match /#{version}/, shell_output("#{bin}/dspdfviewer --version", 0)
  end
end
