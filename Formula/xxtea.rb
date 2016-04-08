class Xxtea < Formula
  desc "Extremely fast encryption algorithm library for C"
  homepage "https://github.com/xxtea/xxtea-c"
  url "https://github.com/xxtea/xxtea-c/archive/v1.0.tar.gz"
  sha256 "bf02e600649c2589d321f7e88027bb873226f718ff5580a442232717f6a3f4bc"
  bottle do
    cellar :any
    sha256 "50fb846c370c71b75af62fa846ce3b0192378ca4b9d9c5e5d6e0b09a184eeb7c" => :el_capitan
    sha256 "0491699e52b0c11653f0c899a23a4320a5f85181e715668da36956dc4217ae1a" => :yosemite
    sha256 "a7b608d782fed42a63dcabfaf5cc10067965ee84bf932aa1a4f6b2dbe9226be0" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
  end
end
