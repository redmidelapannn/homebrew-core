class Xhyve < Formula
  desc "Lightweight macOS virtualization solution based on FreeBSD's bhyve"
  homepage "https://github.com/machyve/xhyve"
  url "https://github.com/machyve/xhyve/archive/v0.2.0.tar.gz"
  sha256 "32c390529a73c8eb33dbc1aede7baab5100c314f726cac14627d2204ad9d3b3c"
  head "https://github.com/machyve/xhyve.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "f0123da07c841bc8601a51822e5dc3d235424246ae7a0bff6bd9bdba6afc1392" => :mojave
    sha256 "abdd1e680d83404c7051bef6b770eea291e0384aafee1d3d891e31c1d36e45b0" => :high_sierra
    sha256 "c5406d4baa2acd9ac62a6cb8c76cb26210b37dc9cfe46df6006d38ec4a5b1376" => :sierra
  end

  depends_on :macos => :yosemite

  def install
    args = []
    args << "GIT_VERSION=#{version}" if build.stable?
    system "make", *args
    bin.install "build/xhyve"
    pkgshare.install "test/"
    pkgshare.install Dir["xhyverun*.sh"]
    man1.install "xhyve.1" if build.head?
  end

  test do
    system "#{bin}/xhyve", "-v"
  end
end
