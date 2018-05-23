class Uchardet < Formula
  desc "Encoding detector library"
  homepage "https://www.freedesktop.org/wiki/Software/uchardet/"
  url "https://www.freedesktop.org/software/uchardet/releases/uchardet-0.0.6.tar.xz"
  sha256 "8351328cdfbcb2432e63938721dd781eb8c11ebc56e3a89d0f84576b96002c61"
  head "https://anongit.freedesktop.org/git/uchardet/uchardet.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "14c8cf07f60741ff0194dc1024e4c4ceb61fb0469e48fb4108d7f518976d5f16" => :high_sierra
    sha256 "1226b6bd3dbdd7cc2040b734bce8bb70057d0a9aee8e449193c86c43d89d11ec" => :sierra
    sha256 "870dbdaeb2e0024a526068612d11eb850a75eced13ba279b2a1b3227addd6dc3" => :el_capitan
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
