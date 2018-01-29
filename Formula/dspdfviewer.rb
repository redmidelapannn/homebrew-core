class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "http://dspdfviewer.danny-edel.de"
  url "https://github.com/dannyedel/dspdfviewer/archive/v1.15.1.tar.gz"
  sha256 "c5b6f8c93d732e65a27810286d49a4b1c6f777d725e26a207b14f6b792307b03"
  revision 5

  head "https://github.com/dannyedel/dspdfviewer.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a16cdd66f6c44d6189efdc811bd24db99d612a0b67aa590e66362cc6298cb846" => :high_sierra
    sha256 "f683157bad4da1f43861dda541b2676a8929af87f875e2bd6b5c50fd5012818a" => :sierra
    sha256 "f1fdbe2c6c182a850d8d23defc393d0c7225ddb7635d58ec7e8a5b875950fc33" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "poppler"
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
    require "pty"
    PTY.spawn(bin/"dspdfviewer", test_fixtures("test.pdf")) do |_stdout, stdin, _pid|
      sleep 2
      stdin.write "q"
    end
  end
end
