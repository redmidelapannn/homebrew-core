class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.13.5.tar.gz"
  sha256 "9c62ff8fefc5999a07ba8c16158fe0d574ec6cbe7b359d405b17d6fa97bad73c"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3521c6fba835064918c2d40880946464c651b01ce013c9d802ec859859a0621a" => :catalina
    sha256 "342e8f97a2de2d041cae66cdcf11f586f3f7510747e8bcdd1a3d26a605ee7784" => :mojave
    sha256 "6e86c0ce8ae663c808be0af7b63335235e9a55713eeba64f52d4195bfe6aebb5" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match "A tree explorer and a customizable launcher", shell_output("#{bin}/broot --help 2>&1")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "--cmd", ":pt", "--no-style", "--out", testpath/"output.txt", :err => :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency termimad requires width > 2
      w.write "n\r"
      assert_match "New Configuration file written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
