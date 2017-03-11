class Sz81 < Formula
  desc "ZX80/81 emulator"
  homepage "https://sz81.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sz81/sz81/2.1.7/sz81-2.1.7-source.tar.gz"
  sha256 "4ad530435e37c2cf7261155ec43f1fc9922e00d481cc901b4273f970754144e1"
  head "https://svn.code.sf.net/p/sz81/code/sz81"

  bottle do
    rebuild 1
    sha256 "8731d47c5dccdb37e3b6f6141e4822e08fe4b7fd0deb9c3923befdea75146240" => :sierra
    sha256 "323b33b6d53612ba52fa7bbfa5b3ffd84412b1ee2781c4ab819908e2cc637cf0" => :el_capitan
    sha256 "3be8b9679034f83d8f69924d117f2e8078d9e55a24acdda78017330ca9b134f4" => :yosemite
  end

  depends_on "sdl"

  def install
    args = %W[
      PREFIX=#{prefix}
      BINDIR=#{bin}
    ]
    system "make", *args
    system "make", "install", *args
  end

  test do
    assert_match /sz81 #{version} -/, shell_output("#{bin}/sz81 -h", 1)
  end
end
