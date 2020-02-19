class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://ziglang.org/download/0.5.0/zig-0.5.0.tar.xz"
  sha256 "55ae16960f152bcb9cf98b4f8570902d0e559a141abf927f0d3555b7cc838a31"
  head "https://github.com/ziglang/zig.git"

  bottle do
    rebuild 1
    sha256 "4edb7402de1ace6c04074f6ea3f15c028a994ac9f9432ad3ee66398de1af79b4" => :catalina
    sha256 "76196fdd741ce042497646b2c17b0901aed1809f0ed5854b2b899534b29c22b0" => :mojave
    sha256 "c7b6802cd66b57278cdc8129ab439b357ea36d2c59296ecfaed244c542208293" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def install
    ENV["CC"] = Formula["llvm"].opt_bin/"clang"
    ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"
    ENV["LD"] = Formula["llvm"].opt_bin/"ld.lld"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"hello.zig").write <<~EOS
      const std = @import("std");
      pub fn main() !void {
          var stdout_file = try std.io.getStdOut();
          try stdout_file.write("Hello, world!");
      }
    EOS
    system "#{bin}/zig", "build-exe", "hello.zig"
    assert_equal "Hello, world!", shell_output("./hello")
  end
end
