class Komposition < Formula
  desc "Video editor built for screencasters"
  homepage "https://github.com/owickstrom/komposition"
  url "https://github.com/owickstrom/komposition/archive/v0.2.0.tar.gz"
  sha256 "cedb41c68866f8d6a87579f566909fcd32697b03f66c0e2a700a94b6a9263b88"
  head "https://github.com/owickstrom/komposition.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ccc1cf68a43eb73a2bb1b6744d24c208bc3146af9ae78aa4ff7239e617fe7b0b" => :catalina
    sha256 "66a919c897b28a77479d84c48f44079aea7e85ac89d1867d6abc10aab39e488c" => :mojave
    sha256 "a88c27b4ac385f749d8d826844b5d80949c9549b9881d6488c55d68f67b370fa" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "gobject-introspection"
  depends_on "gst-libav"
  depends_on "gst-plugins-base"
  depends_on "gst-plugins-good"
  depends_on "gstreamer"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "sox"

  uses_from_macos "libffi"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    output = shell_output "#{bin}/komposition doesnotexist 2>&1"
    assert_match "[ERROR] Opening existing project failed: ProjectDirectoryDoesNotExist \"doesnotexist\"", output
  end
end
