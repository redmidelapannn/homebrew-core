class IosDeploy < Formula
  desc "Install and debug iPhone apps from the command-line"
  homepage "https://github.com/ios-control/ios-deploy"
  url "https://github.com/ios-control/ios-deploy/archive/1.10.0.tar.gz"
  sha256 "619176b0a78f631be169970a5afc9ec94b206d48ec7cb367bb5bf9d56b098290"
  head "https://github.com/ios-control/ios-deploy.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "84f5e08983fddeca936cec29a7f25e5585be17a8fb308a8dc65c7f664f6308ce" => :catalina
    sha256 "11a08ff264988ea802f9995eb4c39579465d8bce92aa3f52d0b361783d08289f" => :mojave
    sha256 "7f81ae82f241631c5e91db5328fe00ddf6fca9fac17d995982bb9d663a41dbdf" => :high_sierra
  end

  depends_on :xcode => :build
  depends_on :macos => :yosemite

  def install
    xcodebuild "-configuration", "Release", "SYMROOT=build"

    xcodebuild "test", "-scheme", "ios-deploy-tests", "-configuration", "Release", "SYMROOT=build"

    bin.install "build/Release/ios-deploy"
    include.install "build/Release/libios_deploy.h"
    lib.install "build/Release/libios-deploy.a"
  end

  test do
    system "#{bin}/ios-deploy", "-V"
  end
end
