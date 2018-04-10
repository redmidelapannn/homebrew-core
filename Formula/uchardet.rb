class Uchardet < Formula
  desc "Encoding detector library"
  homepage "https://www.freedesktop.org/wiki/Software/uchardet/"
  url "https://www.freedesktop.org/software/uchardet/releases/uchardet-0.0.6.tar.xz"
  sha256 "8351328cdfbcb2432e63938721dd781eb8c11ebc56e3a89d0f84576b96002c61"
  head "git://anongit.freedesktop.org/uchardet/uchardet"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b4cdfb2460ffd75b0ec3e2936f142f2aedd67f0e50a6e0ec7d3a73c90417d7d2" => :high_sierra
    sha256 "e0642cb742e2496be4e1edb9dbdf1f71063a81e80eba662b1c80606fe05df1c5" => :sierra
    sha256 "d87d623df7ebc95a3dbc61cf7fe7594612d2c3abb9d2ae517416e0924cf1ab70" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DCMAKE_INSTALL_NAME_DIR=#{lib}"
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    assert_equal "ASCII", pipe_output("#{bin}/uchardet", "Homebrew").chomp
  end
end
