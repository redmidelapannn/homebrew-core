class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/0.5.0/dav1d-0.5.0.tar.bz2"
  sha256 "b29c159bf7c56e8b6ae81bb24704599819fa89399ec3d6db3dbc052d7bc5baf8"

  bottle do
    cellar :any
    sha256 "30deda38183407fa18c66b026e153e1b8285a7cba54ce3ba1382b1722d8a131f" => :catalina
    sha256 "7d0aaccdb3bf1f472f5437329ce8b57872e4f86bf95a846a472037b748557cd0" => :mojave
    sha256 "651c7826cf9125e467802ae11143e348c1f1a13fd9615bc7015ed6ad40f5a68d" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build

  resource "00000000.ivf" do
    url "https://code.videolan.org/videolan/dav1d-test-data/raw/master/8-bit/data/00000000.ivf"
    sha256 "52b4351f9bc8a876c8f3c9afc403d9e90f319c1882bfe44667d41c8c6f5486f3"
  end

  def install
    system "meson", "--prefix=#{prefix}", "build", "--buildtype", "release"
    system "ninja", "install", "-C", "build"
  end

  test do
    testpath.install resource("00000000.ivf")
    system bin/"dav1d", "-i", testpath/"00000000.ivf", "-o", testpath/"00000000.md5"

    assert_predicate (testpath/"00000000.md5"), :exist?
    assert_match "0b31f7ae90dfa22cefe0f2a1ad97c620", (testpath/"00000000.md5").read
  end
end
