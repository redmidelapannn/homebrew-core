class Sslh < Formula
  desc "Forward connections based on first data packet sent by client"
  homepage "https://www.rutschle.net/tech/sslh.shtml"
  url "https://www.rutschle.net/tech/sslh/sslh-v1.18.tar.gz"
  sha256 "1601a5b377dcafc6b47d2fbb8d4d25cceb83053a4adcc5874d501a2d5a7745ad"
  head "https://github.com/yrutschle/sslh.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "29d8ee8dc0bdcc7163409ed319d60092b31b728af61a3030f15c62dbd5cc3b2a" => :sierra
    sha256 "84d8d83abeba3ebd3b4da747f1fc5a8473cf9ec6c34fd1849af41b598473cf9d" => :el_capitan
    sha256 "04cb14a67b34570d07c2cb14144bcb6b766c6fc885f0b369971361f3c8bb882c" => :yosemite
  end

  depends_on "libconfig"

  def install
    ENV.deparallelize
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/sslh -V")
  end
end
