class Nnn < Formula
  desc "Free, fast, friendly file browser"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v1.3.1.tar.gz"
  sha256 "869ff4fd6441ae7c9e2d135504f1c71b5818502081de305fbd0e2dc43b414270"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e0b548b8258f7ef7428f6b1c565acd037b06c9544ee2e7a3af2f86fcafe4273" => :sierra
    sha256 "c4481b2bedfab3c4ae921e5c8dd65f2db60d9b9e6be921ece61941bfb51b56c6" => :el_capitan
    sha256 "bcc373a9921ba8fe76594dc973aebf7d5b1333198b405c78eb485a423c8744bf" => :yosemite
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Testing this curses app requires a pty
    require "pty"
    PTY.spawn(bin/"nnn") do |r, w, _pid|
      w.write "q"
      assert_match "cwd: #{testpath.realpath}", r.read
    end
  end
end
