class Itpp < Formula
  desc "Library of math, signal, and communication classes and functions"
  homepage "https://itpp.sourceforge.io"
  url "https://downloads.sourceforge.net/project/itpp/itpp/4.3.1/itpp-4.3.1.tar.bz2"
  sha256 "50717621c5dfb5ed22f8492f8af32b17776e6e06641dfe3a3a8f82c8d353b877"
  head "https://git.code.sf.net/p/itpp/git.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1636d8d4171e9250dacb606db542df4921b8d1a0038d4b01bfcf8d0e0d27002d" => :sierra
    sha256 "2b070e9d35041db52de4c6aa0cd89d1709ee69352d894371ed81255f58d204a5" => :el_capitan
    sha256 "8e7f267521c6af26d80cf385309365d4f2960b4caf21c1c06d2c1bbc8c4fd4fb" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "fftw" => :recommended

  def install
    mkdir "build" do
      args = std_cmake_args
      args.delete "-DCMAKE_BUILD_TYPE=None"
      args << "-DCMAKE_BUILD_TYPE=Release"
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end
end
