class Oclgrind < Formula
  desc "OpenCL device simulator and debugger"
  homepage "https://github.com/jrprice/Oclgrind"
  url "https://github.com/jrprice/Oclgrind/archive/v16.10.tar.gz"
  sha256 "f2c05ef7e283d9071e07ed6674c199b4b33da44b2e0fdb04d3fd8fe82d388744"

  bottle do
    cellar :any
    sha256 "7fcef931224de51762712a41a1a087e7002b734aad2d0b33edac6b8b94fe93c2" => :high_sierra
    sha256 "7386dfd0d1bae707e759e30159804b1e63383b2da2aefd7dc01e49f438db4760" => :sierra
    sha256 "4af5b5fb0f7e5f7c4611288cdd470e0299370ffc750f5c18ab44ccba0d70de99" => :el_capitan
  end

  depends_on "llvm@3.9" => :build
  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/oclgrind", "ls", "-l"
  end
end
