class Rpcgen < Formula
  desc "Protocol Compiler"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/developer_cmds/developer_cmds-63.tar.gz"
  sha256 "d4bc4a4b1045377f814da08fba8b7bfcd515ef1faec12bbb694de7defe9a5c0d"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "279358ea0efa1a8703fbcff57285ae0bf86d13de5a23db3407a42c5a24732e14" => :catalina
    sha256 "82c764505540e84f54a4472246660a32c944a1a143604df0d41c912ddb4f0254" => :mojave
    sha256 "7989ecf4b0e81192bbbc6aa11d2f42d723c82d05cf2b14fa172f63e27cf8f3a2" => :high_sierra
  end

  keg_only :provided_by_macos

  depends_on :xcode => ["7.3", :build]

  # Add support for parsing 'hyper' and 'quad' types, as per RFC4506.
  # https://github.com/openbsd/src/commit/26f19e833517620fd866d2ef3b1ea76ece6924c5
  # https://github.com/freebsd/freebsd/commit/15a1e09c3d41cb01afc70a2ea4d20c5a0d09348a
  # Reported to Apple 13 Dec 2016 rdar://29644450
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/rpcgen/63.patch"
    sha256 "d687d74e1780ec512c6dacf5cb767650efa515a556106400294393f5f06cf1db"
  end

  def install
    xcodebuild "-project", "developer_cmds.xcodeproj",
               "-target", "rpcgen",
               "-configuration", "Release",
               "SYMROOT=build"
    bin.install "build/Release/rpcgen"
    man1.install "rpcgen/rpcgen.1"
  end

  test do
    assert_match "nettype", shell_output("#{bin}/rpcgen 2>&1", 1)
  end
end
