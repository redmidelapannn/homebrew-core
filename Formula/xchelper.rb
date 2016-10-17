class Xchelper < Formula
  desc "Build your Swift code on Linux with Xcode. Archive and upload to S3."
  homepage "https://github.com/saltzmanjoelh/XcodeHelper"
  url "https://github.com/saltzmanjoelh/XcodeHelper/archive/master.tar.gz"
  version "1.0.10"
  sha256 "5b69efd533d89e3a6d202e9021df27a958533d691e64cfb2192713d7acbc1597"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a416c28734996f163aa7373adfb802ad5fe1cc4e20f2b49ca95ce2911325de7" => :sierra
    sha256 "7a416c28734996f163aa7373adfb802ad5fe1cc4e20f2b49ca95ce2911325de7" => :el_capitan
  end

  def install
    system "swift", "build", "--configuration", "release"
    bin.install "./.build/release/xchelper"
  end

  def uninstall
    system "swift", "build", "--configuration", "release"
    bin.install "./.build/release/xchelper"
  end

  test do
    system "swift", "test"
  end
end
