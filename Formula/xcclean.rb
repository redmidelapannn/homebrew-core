class Xcclean < Formula
  desc "Recover disk space from Xcode."
  homepage "https://hectique.github.io/xcclean/"
  url "https://github.com/hectique/xcclean/archive/1.0.tar.gz"
  version "1.0"
  sha256 "23af560d848b455d6119453edffa3f86a683f8635e19e35414829b3dbd0d9f8d"

  bottle do
    cellar :any_skip_relocation
    sha256 "96583d08f166a247d9d7d4fca30400aa6b577594d61128ce22d1a81bd4fdb9d1" => :el_capitan
  end

  depends_on :macos => :el_capitan

  def install
    xcodebuild "-project", "xcclean.xcodeproj",
               "-target", "xcclean",
               "-configuration", "Release",
               "clean", "install",
               "SYMROOT=build",
               "DSTROOT=build",
               "INSTALL_PATH=/bin"
    bin.install "build/bin/xcclean"
  end

  test do
    system "false"
  end
end
