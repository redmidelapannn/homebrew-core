class Xhyve < Formula
  desc "Lightweight macOS virtualization solution based on FreeBSD's bhyve"
  homepage "https://github.com/mist64/xhyve"
  url "https://github.com/mist64/xhyve/archive/v0.2.0.tar.gz"
  sha256 "32c390529a73c8eb33dbc1aede7baab5100c314f726cac14627d2204ad9d3b3c"
  head "https://github.com/mist64/xhyve.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "84181969bba4066d8827332327b420f0116b0ba1104ed37c184a52c468eabf7b" => :high_sierra
    sha256 "b9fb5c7b317e24c678353ec4562e9357c22b9e53f3e01439ae9ea4beddaa2e12" => :sierra
    sha256 "bf6627431b301855145cb42af8f963fe25b4737b0847de81687e91bb5719b7b3" => :el_capitan
  end

  depends_on :macos => :yosemite

  def install
    args = []
    args << "GIT_VERSION=#{version}" if build.stable?
    system "make", *args
    bin.install "build/xhyve"
    pkgshare.install "test/"
    pkgshare.install "xhyverun.sh"
    man1.install "xhyve.1" if build.head?
  end

  test do
    system "#{bin}/xhyve", "-v"
  end
end
