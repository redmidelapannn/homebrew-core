class Xhyve < Formula
  desc "xhyve, lightweight macOS virtualization solution based on FreeBSD's bhyve"
  homepage "https://github.com/dwoz/xhyve"
  url "https://github.com/dwoz/xhyve/archive/v0.2.0.tar.gz"
  sha256 "32c390529a73c8eb33dbc1aede7baab5100c314f726cac14627d2204ad9d3b3c"
  head "https://github.com/dwoz/xhyve.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "abebd302f13b2986f2b521c374cc60a18ce313d8f6eec6b91c2a49e726fc7c13" => :sierra
    sha256 "201963fe358a37772b2b5175273248cea23f722661f88b1cb453b80fe233ad5c" => :el_capitan
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
