class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "http://ziglang.org/"
  url "https://github.com/zig-lang/zig/archive/0.1.1.tar.gz"
  sha256 "fabbfcb0bdb08539d9d8e8e1801d20f25cb0025af75ac996f626bb5e528e71f1"

  head "https://github.com/zig-lang/zig.git"

  bottle do
    rebuild 1
    sha256 "534e081f6dfe1f60ef51cdd983e4bfd549e934b9fc7c13efdf19f871ef58c843" => :high_sierra
    sha256 "fd996391b5d2799c30d36d6e1ce4a8e226d4ad8780e679c7e55d769ad0aa5407" => :sierra
    sha256 "a0e9661493e08eda14bdde1b87ff2242f464f7e8cd9ee7795cba0d7b8ba437d1" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"hello.zig").write <<~EOS
      const io = @import("std").io;
      pub fn main() -> %void {
          %%io.stdout.printf("Hello, world!");
      }
    EOS
    system "#{bin}/zig", "build-exe", "hello.zig"
    assert_equal "Hello, world!", shell_output("./hello")
  end
end
