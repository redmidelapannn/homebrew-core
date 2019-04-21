require "English"

class Icecast < Formula
  desc "Streaming MP3 audio server"
  homepage "https://icecast.org/"
  url "https://downloads.xiph.org/releases/icecast/icecast-2.4.4.tar.gz"
  sha256 "49b5979f9f614140b6a38046154203ee28218d8fc549888596a683ad604e4d44"

  bottle do
    cellar :any
    sha256 "432ee4fd2a0741e67ba7a737218dd42f19ef43a7ca6f58a289c7cec3e005ed95" => :mojave
    sha256 "f7c4b1c5ff5841a4dc5f15bc2ce977446d711595fb0bd7ab6e51fe471cdfc9bb" => :high_sierra
    sha256 "fa7a1623a4e04522a706b3fdb0a64ee77a5857dc3a05b0794597c215beb24ef2" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libvorbis"
  depends_on "libxslt" if MacOS.version == :sierra
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    (prefix+"var/log/icecast").mkpath
    touch prefix+"var/log/icecast/error.log"
  end

  test do
    ICECAST_PID = spawn "icecast", "-c", "#{prefix}/etc/icecast.xml", "2>", "/dev/null"
    sleep(3)

    begin
      system "kill", "-0", ICECAST_PID
      assert_equal 0, $CHILD_STATUS.exitstatus

      system "kill", ICECAST_PID
      assert_equal 0, $CHILD_STATUS.exitstatus
    ensure
      Process.kill("TERM", ICECAST_PID)
    end
  end
end
