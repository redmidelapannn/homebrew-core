class Nef < Formula
  desc "Tool to compile Swift docs written in Playground format with Bow support"
  homepage "https://github.com/bow-swift/nef"
  url "https://github.com/bow-swift/nef/archive/0.1.0.tar.gz"
  sha256 "ec982a271c55e0003f03821dbf8f11306b28f232c8a6df3f5cbfdb11b8d4cbf5"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0d13c3d49ecce7b358db3e77e6575561c6f871176e95d96cafd65fdd8d05586" => :mojave
    sha256 "1324d423b61861e1677c85ed705e53b1fdcadb3310359988057af0145d9f2d0c" => :high_sierra
  end

  depends_on "cocoapods"
  depends_on :xcode => "10.0"

  def install
    build_jekyll_page
    bin.install "./bin/nef"
    bin.install "./bin/nefc"
    bin.install "./bin/nef-playground"
    bin.install "./bin/nef-jekyll-page"
    bin.install "./bin/nef-jekyll"
  end

  test do
    print ""
  end

  def build_jekyll_page
    xcodebuild "-project", "./markdown/JekyllMarkdown.xcodeproj", "-scheme", "JekyllMarkdown", "-configuration", "Release", "clean", "build",
    "SYMROOT=/tmp/nef/Build/Products", "-derivedDataPath", "/tmp/nef"
    mv "/tmp/nef/Build/Products/Release/JekyllMarkdown", "./bin/nef-jekyll-page"
    rm "/tmp/nef/", :force => true
  end
end
