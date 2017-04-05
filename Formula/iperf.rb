class Iperf < Formula
  desc "Tool to measure maximum TCP and UDP bandwidth"
  homepage "https://iperf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/iperf/iperf-2.0.5.tar.gz"
  sha256 "636b4eff0431cea80667ea85a67ce4c68698760a9837e1e9d13096d20362265b"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "6a2b737d9ed1c9332387c59483145dcc8557301757c1c07a8b9225e2910b1bba" => :sierra
    sha256 "641dc23ab0810892ba6199ae1430af79040051204ccdb1d85c6ad145437078b7" => :el_capitan
    sha256 "af850a51b9f102e588207115923d4a7e66deda2a2c6c9dc2a037d24983793dc4" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
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
