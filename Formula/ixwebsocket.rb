class Ixwebsocket < Formula
  desc "WebSocket client and server, and HTTP client command-line tool"
  homepage "https://github.com/machinezone/IXWebSocket"
  url "https://github.com/machinezone/IXWebSocket/archive/v1.1.0.tar.gz"
  sha256 "52592ce3d0a67ad0f90ac9e8a458f61724175d95a01a38d1bad3fcdc5c7b6666"
  bottle do
    cellar :any_skip_relocation
    sha256 "30d1f4195a2216a28cb1b700f4b0ccaf955bb0e6415673db044f7c7d292cb0a0" => :mojave
    sha256 "2ef62b771e811fd4efa5a8b350391f613110f016528c3d3910e555ca26222d01" => :high_sierra
    sha256 "4b6ee95beb56d3015e5f356af355ed37483e0110c8947cae928a128448467f91" => :sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/ws", "--help"
    system "#{bin}/ws", "send", "--help"
    system "#{bin}/ws", "receive", "--help"
    system "#{bin}/ws", "transfer", "--help"
    system "#{bin}/ws", "curl", "--help"
  end
end
