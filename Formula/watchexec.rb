class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/mattgreen/watchexec"
  url "https://github.com/mattgreen/watchexec/archive/1.8.6.tar.gz"
  sha256 "4caa882a17d3e826dca92af157382145c599ac204e9b9ea810dc309402a200e8"

  bottle do
    rebuild 1
    sha256 "9a189c5c94c37678a3c96c35bedb8c9d6d7d23966e2434a1b09a76f07f70f5d2" => :high_sierra
    sha256 "25e12dc08033470f59020fe1303b06408c8872f8d0368010f6a0fbb9ace8d847" => :sierra
    sha256 "3111a7e504f0b5f7f0647cce2280ff043c9f44fd69d107dbd0a01c251a70420e" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -- echo 'saw file change'")
    sleep 0.1
    Process.kill("INT", o.pid)
    assert_match "saw file change", o.read
  end
end
