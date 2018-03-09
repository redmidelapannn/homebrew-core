class StreamStats < Formula
  desc "Stdin throughput statistics"
  homepage "https://github.com/ddrscott/stream_stats"
  url "https://github.com/ddrscott/stream_stats/archive/v0.1.0.tar.gz"
  sha256 "5df10e79754c877b379f89ad1d244df21359e2b5b1d9cd33b11c865a1d29f61c"

  bottle do
    sha256 "1dc2004dd1a0e292ae90f956e77e34aaaa19d97f9b526671728b9f8760e9b344" => :high_sierra
    sha256 "2a1475dd52603d4f780e458a677916afb5f7eff2445e8acf1ae60c8ff19cff2a" => :sierra
    sha256 "a7d71775ac8060a5e3681bc5c0a4460b44d316c73222f7c9d0423466c227e495" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/stream_stats"
  end

  test do
    system "head -100 /dev/random | #{bin/"stream_stats"} > /dev/null"
  end
end
