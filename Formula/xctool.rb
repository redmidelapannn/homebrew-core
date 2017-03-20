class Xctool < Formula
  desc "Drop-in replacement for xcodebuild with a few extra features"
  homepage "https://github.com/facebook/xctool"
  url "https://github.com/facebook/xctool/archive/0.3.1.tar.gz"
  sha256 "9db246a95af6716cca93a57b45905c97b3228c1167b4ae7c9461715cfb3e9df0"
  head "https://github.com/facebook/xctool.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "875b97b42b9f336ea196ac21310686e84ae2e68036e718b683c7fb12011a3ab0" => :sierra
    sha256 "2768bc186df02461ff17be22d00c8e76bbebf2d46c3e32e4efc957a9325022f6" => :el_capitan
    sha256 "658a3930bec947f0ad3acfd232e908fd997f7cb6f728d84aea7292dede3ad09d" => :yosemite
  end

  depends_on :xcode => "7.0"

  def install
    system "./scripts/build.sh", "SYMROOT=build", "XT_INSTALL_ROOT=#{libexec}", "-IDECustomDerivedDataLocation=#{buildpath}"
    bin.install_symlink "#{libexec}/bin/xctool"
  end

  def post_install
    # all libraries need to be signed to avoid codesign errors when
    # injecting them into xcodebuild or Simulator.app.
    Dir.glob("#{libexec}/lib/*.dylib") do |lib_file|
      system "/usr/bin/codesign", "-f", "-s", "-", lib_file
    end
  end

  test do
    system "(#{bin}/xctool -help; true)"
  end
end
