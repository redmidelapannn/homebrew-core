class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.13.6.tar.gz"
  sha256 "f28eea78bba1660ecdbdb9ebac8e215b7523b94f7d490d69d8022df44eacec3c"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ad812472788bbfaf33b0d368077a6d007eb3c44949603bb089813c5ced62d7f" => :catalina
    sha256 "08fad89843b1dc6d66e1efca1b9c7507c2103f2899530630412bfe3a54c1cbf9" => :mojave
    sha256 "9c202622d9ffafb1c41f91cd0510a78b1f87ba78f50de55dc47df2c2b6110551" => :high_sierra
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
