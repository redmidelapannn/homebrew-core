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
    sha256 "0458e62465899ef9e550fbd81fcc0cc1e77365f824f8d1a17fbae00450d17239" => :high_sierra
    sha256 "0785afdcd51f80d1840b70fa1a6e9c4fa2eb66746cebe357d2ede4205240eacd" => :sierra
    sha256 "da034d4d7f02411022cffc3f0acc40102fc8f791fc9aed66515283d078f2bb87" => :el_capitan
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
    require "pty"
    PTY.spawn(bin/"dspdfviewer", test_fixtures("test.pdf")) do |stdout, stdin, pid|
      # wait for the program to start
      sleep 2
      # quit the program by sending q via stdin.write
      stdin.write "q"
    end 
  end
end
