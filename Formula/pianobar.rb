class Pianobar < Formula
  desc "Command-line player for https://pandora.com"
  homepage "https://github.com/PromyLOPh/pianobar/"
  url "https://6xq.net/pianobar/pianobar-2019.02.14.tar.bz2"
  sha256 "c0bd0313b31492ed266d1932d319cfe2a4be7024686492c458bb5e4ceb0ee21f"
  revision 1
  head "https://github.com/PromyLOPh/pianobar.git"

  bottle do
    cellar :any
    sha256 "7d99b36c21c59e58129c0f2c3b257aa912daaba107807973f6b24b0944563fbc" => :catalina
    sha256 "32b800b1974cffb49cd4c35099912de92f1fa2576242e2595339ffedacab2104" => :mojave
    sha256 "42d032c117225f7d06baecffe862e736b5f0abd6d6edf718ed29d1a075c99dc3" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "json-c"
  depends_on "libao"
  depends_on "libgcrypt"

  def install
    # Discard Homebrew's CFLAGS as Pianobar reportedly doesn't like them
    ENV["CFLAGS"] = "-O2 -DNDEBUG " +
                    # Or it doesn't build at all
                    "-std=c99 " +
                    # build if we aren't /usr/local'
                    "#{ENV.cppflags} #{ENV.ldflags}"
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"

    prefix.install "contrib"
  end

  test do
    require "pty"
    PTY.spawn(bin/"pianobar") do |stdout, stdin, _pid|
      stdin.putc "\n"
      assert_match "pianobar (#{version})", stdout.read
    end
  end
end
