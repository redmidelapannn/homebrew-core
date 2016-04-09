class IosSim < Formula
  desc "Command-line application launcher for the iOS Simulator"
  homepage "https://github.com/phonegap/ios-sim"
  url "https://github.com/phonegap/ios-sim/archive/3.2.0.tar.gz"
  sha256 "7bde9ecde402b4907fa4bb473e6dff4f6000bf78d970e6df917fa904b9d6c645"
  head "https://github.com/phonegap/ios-sim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a523e142256541545ac7f39c8c730cbac3eeb3386844bcbd9eec3994bd50e136" => :el_capitan
    sha256 "80b504ecfb9b50a23fe9cb5241997e11d0c2ff9eb70ed9b361ea4c3ed21580a9" => :yosemite
    sha256 "08f003a455cfcf2405ba6d1973389c963b9845db40629172c615d821e8b43012" => :mavericks
  end

  depends_on :macos => :mountain_lion

  def install
    rake "install", "prefix=#{prefix}"
  end
end
