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
    sha256 "d739be1541dfa9ea06f178793056a50bcdc59ad207f1e46f8ca02c9f915c359d" => :high_sierra
    sha256 "ed4e82560b7d00b063808bf5eda171dcc97c7be4318f29fd7cdec306d4b9d323" => :sierra
    sha256 "c8232af996627cffe55af84ca4f1075e137ecfe8db25ac6fdb09356b8c27f6c3" => :el_capitan
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
    PTY.spawn(bin/"dspdfviewer", test_fixtures("test.pdf")) do |_stdout, stdin, _pid|
      # wait for the program to start
      sleep 2
      # quit the program by sending q via stdin.write
      stdin.write "q"
    end
  end
end
