class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://primesieve.org/"
  url "https://github.com/kimwalisch/primesieve/archive/v6.3.tar.gz"
  sha256 "d359575d17979c01f19203e61849d1bfea1867de0005e119f15f2f37ae2af83f"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ca95acba7cf7bb290500afb732fb3374c8e3e86ed0723508cbc370411796f7c7" => :high_sierra
    sha256 "3ccf8979896a682291dd9646628428c3cbdb6e821b4946e657f6fac317b04764" => :sierra
    sha256 "e27109815b0c26de1160d28750defa236346869265a04d8b59fce867dcaa1bca" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/primesieve", "100", "--count", "--print"
  end
end
