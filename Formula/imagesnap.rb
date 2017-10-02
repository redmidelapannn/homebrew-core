class Imagesnap < Formula
  desc "Tool to capture still images from an iSight or other video source"
  homepage "https://iharder.sourceforge.io/current/macosx/imagesnap/"
  url "https://downloads.sourceforge.net/project/iharder/imagesnap/ImageSnap-v0.2.5.tgz"
  sha256 "2516edd6e8fe35c075f0a6517b9fb8ba9af296f8f29b9e349566b9ba6f729615"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "9a924482acc3e4cb6bee9464c5259b079d25b74c95e3f46ca21900883cc57b20" => :high_sierra
    sha256 "6d3106b81f5b37ed4b0c8443813598490456f2d6a5c7cd90c536d040b6bbc898" => :sierra
    sha256 "f1745e4a3f27333a80aa3ddccf94f3e0746ca8cfda86cb0f64ede4c2a1892e29" => :el_capitan
  end

  depends_on :xcode => :build

  # Upstream PR from 19 Dec 2015 "Replace QTKit"
  if MacOS::Xcode.version >= "8.0"
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
