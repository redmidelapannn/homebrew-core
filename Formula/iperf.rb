class Iperf < Formula
  desc "Tool to measure maximum TCP and UDP bandwidth"
  homepage "https://iperf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/iperf/iperf-2.0.5.tar.gz"
  sha256 "636b4eff0431cea80667ea85a67ce4c68698760a9837e1e9d13096d20362265b"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "4e0f7ce2ca2bc1ddb7c107f8887f34cc1ec1f2969a39dcf235f50c3e614efba2" => :sierra
    sha256 "dca5a57f66385b36df9e4b3ff72b55e0504e36c13ce8e34901e13fb0a6f7b494" => :el_capitan
    sha256 "d49f47f78a1b5f54841f7070101481e8a45ac88afe051b08112953dcf861005a" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # Otherwise this definition confuses system headers on 10.13
    # https://github.com/Homebrew/homebrew-core/issues/14418#issuecomment-324082915
    if MacOS.version >= :high_sierra
      inreplace "config.h", "#define bool int", ""
    end

    system "make", "install"
  end

  test do
    begin
      server = IO.popen("#{bin}/iperf --server")
      sleep 1
      assert_match "Bandwidth", pipe_output("#{bin}/iperf --client 127.0.0.1 --time 1")
    ensure
      Process.kill("SIGINT", server.pid)
      Process.wait(server.pid)
    end
  end
end
