class Imagesnap < Formula
  desc "Tool to capture still images from an iSight or other video source"
  homepage "https://iharder.sourceforge.io/current/macosx/imagesnap/"
  url "https://downloads.sourceforge.net/project/iharder/imagesnap/ImageSnap-v0.2.5.tgz"
  sha256 "2516edd6e8fe35c075f0a6517b9fb8ba9af296f8f29b9e349566b9ba6f729615"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "6e2abd576418ac6c8eadb79476f176c0c3ea15538590a17f77a846dcc62dd923" => :high_sierra
    sha256 "e6878d64c726bd92fa8d4509a93e3f2787523796a6b09e5835bf68fb71d3f97f" => :sierra
    sha256 "5a07b70195420320f707fa006c6adadb17324e98fa1714fa241d46359d6f6067" => :el_capitan
  end

  depends_on :xcode => :build

  # Upstream PR from 19 Dec 2015 "Replace QTKit"
  if MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
    patch do
      url "https://github.com/rharder/imagesnap/pull/13.patch?full_index=1"
      sha256 "3bef0164843bc229cacdfe04e819515d30b78ee402d76fd2197a8b5d9e5159e9"
    end
  end

  def install
    xcodebuild "-project", "ImageSnap.xcodeproj", "SYMROOT=build", "-sdk", MacOS.sdk_path
    bin.install "build/Release/imagesnap"
  end

  test do
    assert_match "imagesnap", shell_output("#{bin}/imagesnap -h")
  end
end
