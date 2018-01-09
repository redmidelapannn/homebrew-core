class Mplayershell < Formula
  desc "Improved visual experience for MPlayer on macOS"
  homepage "https://github.com/donmelton/MPlayerShell"
  url "https://github.com/donmelton/MPlayerShell/archive/0.9.3.tar.gz"
  sha256 "a1751207de9d79d7f6caa563a3ccbf9ea9b3c15a42478ff24f5d1e9ff7d7226a"

  head "https://github.com/donmelton/MPlayerShell.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d0dbe312554c755df3179b5f49ded4c400266be6e7a5ec445d42754d2d7f73b7" => :high_sierra
    sha256 "20a1f6787adbe5f2bdf04e9ec08c119392feb1946ccfe51bb3e414dc92515258" => :sierra
    sha256 "ac51e19f210ebb13e9cbf401c4db0b12e5e7b4e646dbf25f11a168da146d9574" => :el_capitan
  end

  depends_on "mplayer"
  depends_on :macos => :lion
  depends_on :xcode => :build

  def install
    xcodebuild "-project",
               "MPlayerShell.xcodeproj",
               "-target", "mps",
               "-configuration", "Release",
               "clean", "build",
               "SYMROOT=build",
               "DSTROOT=build"
    bin.install "build/Release/mps"
    man1.install "Source/mps.1"
  end

  test do
    system "#{bin}/mps"
  end
end
