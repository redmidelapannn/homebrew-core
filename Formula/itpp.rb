class Itpp < Formula
  desc "Library of math, signal, and communication classes and functions"
  homepage "https://itpp.sourceforge.io"
  url "https://downloads.sourceforge.net/project/itpp/itpp/4.3.1/itpp-4.3.1.tar.bz2"
  sha256 "50717621c5dfb5ed22f8492f8af32b17776e6e06641dfe3a3a8f82c8d353b877"
  head "https://git.code.sf.net/p/itpp/git.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "655eb41d9c6871758bab9b44d697cc4832beb436ff8de343eddbe3a3a9e90e37" => :mojave
    sha256 "037138c5bc9f536567f6a98bf8cd995f0044f0dc29cf63708269897ebe51edb1" => :high_sierra
    sha256 "2e2416d19b3fa948d1449e90334d30f4f5044979d91480c855a9970bb257c16b" => :sierra
    sha256 "5e92069d6c744c894696f238e0432a225d3e69a4d57d24089f9774e226fb02db" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "fftw"

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
