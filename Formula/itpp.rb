class Itpp < Formula
  desc "Library of math, signal, and communication classes and functions"
  homepage "http://itpp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/itpp/itpp/4.3.1/itpp-4.3.1.tar.bz2"
  sha256 "50717621c5dfb5ed22f8492f8af32b17776e6e06641dfe3a3a8f82c8d353b877"
  head "http://git.code.sf.net/p/itpp/git.git"

  bottle do
    cellar :any
    revision 1
    sha256 "38bbd136f48002fb438ede09d102c49983951cda60dc0905a5cc49027a2a0250" => :el_capitan
    sha256 "9dc10605cbf2d23a83fef93009d2a51b6a601fa99df480bd2fc54b79d106b872" => :yosemite
    sha256 "bb83333649645f20740937a9e7b59e0cfe389b9d3a7313eba2a444ce13deb276" => :mavericks
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
