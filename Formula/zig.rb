class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://github.com/zig-lang/zig/archive/0.1.1.tar.gz"
  sha256 "fabbfcb0bdb08539d9d8e8e1801d20f25cb0025af75ac996f626bb5e528e71f1"

  bottle do
    rebuild 1
    sha256 "c75b1c24bcf3ca68161a040352fd2c818e3f6d570b0f55d32e5c09283d399d42" => :high_sierra
    sha256 "22d012ce488a5d38e3b5c1f08a80114003625697725fa304f46b74da420d51a6" => :sierra
    sha256 "b38b95626f10d460da0cebdc17cddb6dae83b5e1f7b0f7408f715a2c3c72ae72" => :el_capitan
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
