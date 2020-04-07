class Komposition < Formula
  desc "Video editor built for screencasters"
  homepage "https://github.com/owickstrom/komposition"
  url "https://github.com/owickstrom/komposition/archive/v0.2.0.tar.gz"
  sha256 "cedb41c68866f8d6a87579f566909fcd32697b03f66c0e2a700a94b6a9263b88"
  head "https://github.com/owickstrom/komposition.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b922477de63a294207ddf212465d5e38691d2bba46125cf84c7ce00282f99aa1" => :catalina
    sha256 "46acd5f715246e05ef72c4cbc0eeea4152bc485282cebe6fbf5f27abd6a4e405" => :mojave
    sha256 "8af462d81063f6a6703d9371203e43f03e33f8643a7267ac65706afd62cd6e07" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build
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
