class Terminalimageviewer < Formula
  desc "Display images in a terminal using block graphic characters"
  homepage "https://github.com/stefanhaustein/TerminalImageViewer"
  url "https://github.com/stefanhaustein/TerminalImageViewer/archive/v1.0.0.tar.gz"
  sha256 "d28c5746d25d83ea707db52b54288c4fc1851c642ae021951967e69296450c8c"
  head "https://github.com/stefanhaustein/TerminalImageViewer.git"

  bottle do
    cellar :any
    sha256 "be062ec7170665da2b5c2168e3de71df2bde1538232db39545aceeaef2ca045c" => :catalina
    sha256 "e48c2ffc91c82bfe451d1a7708d6faafb45568141e4b804fe31bb6f4d6629c3a" => :mojave
    sha256 "2363f340fc6278598e30156227073483c7909de9e81dc41b513b4c7708e6aaca" => :high_sierra
  end

  depends_on "gcc"
  depends_on "imagemagick"

  def install
    cd "src/main/cpp" do
      # No expermimental/filesystem.h on clang
      system "#{Formula["gcc"].opt_bin}/g++-9", "-std=c++17",
                                                "-Wall",
                                                "-fpermissive",
                                                "-fexceptions",
                                                "-O2", "-c",
                                                "tiv.cpp", "-o", "tiv.o"
      system "#{Formula["gcc"].opt_bin}/g++-9", "tiv.o", "-o", "tiv", "-lstdc++fs", "-pthread", "-s"
      bin.install "tiv"
    end
  end

  test do
    # Downloads a public domain test file from wikimedia commons and displays it.
    # For some reason, when you redirect the output it is blank.
    assert_equal "",
    shell_output("#{bin}/tiv -0 https://upload.wikimedia.org/wikipedia/commons/2/24/Cornell_box.png").strip
  end
end
