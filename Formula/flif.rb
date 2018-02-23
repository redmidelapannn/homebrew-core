class Flif < Formula
  desc "Free Loseless Image Format"
  homepage "https://flif.info/"
  # When updating, please check if FLIF switched to CMake yet
  url "https://github.com/FLIF-hub/FLIF/archive/v0.3.tar.gz"
  sha256 "aa02a62974d78f8109cff21ecb6d805f1d23b05b2db7189cfdf1f0d97ff89498"
  head "https://github.com/FLIF-hub/FLIF.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6afae4791a793338fa27a42dd1b39852006794e2fcd33c5706de0c872a333b61" => :high_sierra
    sha256 "c4c6326aa929ffb3eeff628deccfda295889ae8bafa0301f6c628d4a0317b0a9" => :sierra
    sha256 "3fc1756c93511d5a84c2bc7039d851c61ad1e74b76412af5f37e8ace784f202d" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "sdl2"

  resource "test_c" do
    url "https://raw.githubusercontent.com/FLIF-hub/FLIF/dcc2011/tools/test.c"
    sha256 "a20b625ba0efdb09ad21a8c1c9844f686f636656f0e9bd6c24ad441375223afe"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install", "install-dev"
    doc.install "doc/flif.pdf"
  end

  test do
    testpath.install resource("test_c")
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lflif", "-o", "test"
    system "./test", "dummy.flif"
    system bin/"flif", "-i", "dummy.flif"
    system bin/"flif", "-I", test_fixtures("test.png"), "test.flif"
    system bin/"flif", "-d", "test.flif", "test.png"
    assert_predicate testpath/"test.png", :exist?, "Failed to decode test.flif"
  end
end
