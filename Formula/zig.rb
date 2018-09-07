class Zig < Formula
  desc "Programming language designed for robustness, optimality, and clarity"
  homepage "https://ziglang.org/"
  url "https://github.com/ziglang/zig/archive/0.2.0.tar.gz"
  sha256 "09843a3748bf8a5f1742fe93dbf45699f92051ecf479b23272b067dfc3837cc7"
  head "https://github.com/ziglang/zig.git"

  bottle do
    rebuild 1
    sha256 "00908259640e41dc18f4932d1df24afb53ecba68ab86620600e96958fb4b42f3" => :mojave
    sha256 "93a5479c4e6944e24e9ea34b46ec9b3af802c009c6051486b8dabb55fd67df88" => :high_sierra
    sha256 "c2205bcd136b5308e88dc598171a2270c464263f8ddd610a7fd3ce1b72b21dbd" => :sierra
    sha256 "46c9bdcbd07ae7cb6a95d2a8b576a8149494c03c4a5d1bb72d4061339c24e245" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def install
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
