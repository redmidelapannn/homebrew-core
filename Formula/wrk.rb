class Wrk < Formula
  desc "HTTP benchmarking tool"
  homepage "https://github.com/wg/wrk"
  url "https://github.com/wg/wrk/archive/4.0.1.tar.gz"
  sha256 "c03bbc283836cb4b706eb6bfd18e724a8ce475e2c16154c13c6323a845b4327d"
  head "https://github.com/wg/wrk.git"

  bottle do
    cellar :any
    revision 1
    sha256 "c47594f8311f903a9abcafe824d45a292cf2d7d4de86bd5366c131883b0c8491" => :el_capitan
    sha256 "9089a59de784373ffebc39c520fc676ae07478db8c5e0db923938371331c0304" => :yosemite
    sha256 "ad8e548aa4fffc08e4e1cfb7bdc102ede658305eba2b702089298169a1fc0602" => :mavericks
  end

  depends_on "openssl"

  conflicts_with "wrk-trello", :because => "both install `wrk` binaries"

  def install
    ENV.j1
    system "make"
    bin.install "wrk"
  end

  test do
    system *%W[#{bin}/wrk -c 1 -t 1 -d 1 https://example.com/]
  end
end
