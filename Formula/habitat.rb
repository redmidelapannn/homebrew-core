class Habitat < Formula
  desc "Application automation framework to build applications"
  homepage "https://www.habitat.sh/"

  url "https://habitat.bintray.com/stable/darwin/x86_64/hab-0.7.0-20160614231131-x86_64-darwin.zip"
  sha256 "93fac880261df34c75ac5775c9febb536b82ac955cd6df873bbfec1cf697ed50"

  bottle do
    cellar :any_skip_relocation
    sha256 "da2483624cb0102f7e44f2a7b1f7409f3b570b79b603121d4c3d103a9ea9aa77" => :el_capitan
    sha256 "acba47d45818acd2467b122ad1e45ddb70c3b0e668dedebfd902e5b734cdbd41" => :yosemite
    sha256 "3eeb32605df06c73d0368e3b4b9867336d0f2816f18dd68682ca6e7ee86ca842" => :mavericks
  end

  def install
    bin.install "hab"
  end

  test do
    system "hab", "--help"
  end
end
