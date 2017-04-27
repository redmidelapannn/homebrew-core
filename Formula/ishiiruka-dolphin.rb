class IshiirukaDolphin < Formula
  desc "Custom Dolphin build with reduced graphic thread cpu usage."
  homepage "https://github.com/Tinob/Ishiiruka"
  url "https://github.com/Tinob/Ishiiruka/archive/Stable.tar.gz"
  version "5.0"
  sha256 "8a7b46ff645cd0303a5c7aaaf60bf2f8d39ac1c7a0df161d0385d064812f8e02"
  head "https://github.com/Tinob/Ishiiruka.git"

  option "with-avi-frame-dumps", "AVI Frame dumping support"

  depends_on "cmake" => :build
  depends_on "pulseaudio" => :recommended
  depends_on "libao" => :optional unless build.head?
  depends_on "ffmpeg" if build.with? "avi-frame-dumps"

  def install
    args = ["-DCMAKE_CXX_FLAGS=-std=c++11",
            "-DCMAKE_EXE_LINKER_FLAGS=-lc++"]

    mkdir "build"
    chmod_R 0777, "."
    cd "build"
    system "cmake", "..", *args, *std_cmake_args
    system "make"
    prefix.install "Binaries/Dolphin.app"
  end

  def post_install
    mv prefix/"Dolphin.app", prefix/"Ishiiruka-Dolphin.app"
    system "brew", "linkapps", "ishiiruka-dolphin"
  end

  test do
    pid = Process.spawn prefix/"Ishiiruka-Dolphin.app/Contents/MacOS/Dolphin"
    Process.kill "TERM", pid
  end
end
