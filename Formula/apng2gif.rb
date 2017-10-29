class Apng2gif < Formula
  desc "Convert APNG animations into animated GIF format"
  homepage "https://apng2gif.sourceforge.io/"
  url "https://downloads.sourceforge.net/apng2gif/apng2gif-1.8-src.zip"
  sha256 "9a07e386017dc696573cd7bc7b46b2575c06da0bc68c3c4f1c24a4b39cdedd4d"

  bottle do
    cellar :any
    rebuild 2
    sha256 "a23fc89df757d2a6acc55e66d3013656b719727fd0dc0209b4618782825b87e7" => :high_sierra
    sha256 "c6891cf4ae5fd3915e6430e50df87c18b18d103829a41c9637c1bf093c0d6c2d" => :sierra
    sha256 "90291b6520e129487976723769556e4e558c90106147ba098dbe86a8255d6ffd" => :el_capitan
  end

  depends_on "libpng"

  if MacOS.version <= :yosemite
    depends_on "gcc"
    fails_with :clang
  end

  def install
    system "make"
    bin.install "apng2gif"
  end

  test do
    cp test_fixtures("test.png"), testpath/"test.png"
    system bin/"apng2gif", testpath/"test.png"
    assert_predicate testpath/"test.gif", :exist?, "Failed to create test.gif"
  end
end
