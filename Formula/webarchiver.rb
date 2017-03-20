class Webarchiver < Formula
  desc "allows you to create Safari .webarchive files"
  homepage "https://github.com/newzealandpaul/webarchiver"
  url "https://github.com/newzealandpaul/webarchiver/archive/0.9.tar.gz"
  sha256 "8ea826038e923c72e75a4bbb1416910368140a675421f6aaa51fd0dea703f75c"
  head "https://github.com/newzealandpaul/webarchiver.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "3693d59e91bb7c20909f7e0be6c0a15191a208c671db922f766021bb9962ae39" => :sierra
    sha256 "3693d59e91bb7c20909f7e0be6c0a15191a208c671db922f766021bb9962ae39" => :el_capitan
    sha256 "c1ed451c56dff138d0d605a8abbb16dff06c31402485832cdd162b0b7ef98443" => :yosemite
  end

  depends_on :xcode => ["6.0.1", :build]

  def install
    xcodebuild "SYMROOT=build"
    bin.install "./build/Release/webarchiver"
  end

  test do
    system "#{bin}/webarchiver", "-url", "https://www.google.com", "-output", "foo.webarchive"
    assert_match /Apple binary property list/, shell_output("file foo.webarchive", 0)
  end
end
