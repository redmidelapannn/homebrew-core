class Mrboom < Formula
  desc "Eight player Bomberman clone"
  homepage "http://mrboom.mumblecore.org/"
  url "https://github.com/Javanaise/mrboom-libretro/archive/4.8.tar.gz"
  sha256 "ca41016ced65840d364556ba7477f1d1af2d5b72c98dd1bdf406bea75ad28b71"

  bottle do
    cellar :any
    rebuild 1
    sha256 "65706a6c290b588781d28f011445427851f0d590b87c81fbd5041d890c868f10" => :catalina
    sha256 "ae6740986462377c65b327ef5fcdcb89570277302b1ba343401534c3cb5b07e9" => :mojave
    sha256 "a4fa835c044e2fb13b640b5599f5c8ccb321577c1474ceb671d5d6bac2d79fc2" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libmodplug"
  depends_on "minizip"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  def install
    system "make", "mrboom", "LIBSDL2=1"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    require "pty"
    require "expect"
    require "timeout"
    PTY.spawn(bin/"mrboom", "-m", "-f 0", "-z") do |r, _w, pid|
      sleep 1
      Process.kill "SIGINT", pid
      assert_match "monster", r.expect(/monster/, 10)[0]
    ensure
      begin
        Timeout.timeout(10) do
          Process.wait pid
        end
      rescue Timeout::Error
        Process.kill "KILL", pid
      end
    end
  end
end
