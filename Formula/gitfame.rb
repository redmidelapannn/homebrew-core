class Gitfame < Formula
  desc "Swift CLI that logs your GitHub Stars and Forks."
  homepage "http://www.sabintsev.com"
  url "https://github.com/ArtSabintsev/GitFame.git", :tag => "1.0.0"
  head "https://github.com/ArtSabintsev/GitFame.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cbc37c39b38a5ce770f26e53ceea36c880cf6f2ef76910e71e0265142addff4e" => :sierra
    sha256 "90b0f871530bf5afadfbd8a99af7c6db56ef04170645ce9fc4ad740c9b13204e" => :el_capitan
  end

  def install
    xcodebuild "-project", "GitFame.xcodeproj",
    "CONFIGURATION_BUILD_DIR=build",
    "SYMROOT=."
    bin.install "build/gitfame"
  end

  test do
    system bin/"gitfame", "artsabintsev"
  end
end
