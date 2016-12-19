class Slash < Formula
  desc "Slack terminal client written in Swift."
  homepage "https://github.com/slash-hq/slash"
  url "https://github.com/slash-hq/slash/archive/0.1.0.tar.gz"
  sha256 "8a709579ffba7c47b1e1975bb418d72ecbd542539d4cd6f7a72d876808bfbdb2"

  bottle do
    sha256 "e50bf1357b1b8de7ec49c820824426c6d5b9f32be4a5e0a08451f3d446ab09b7" => :sierra
    sha256 "f6597cd58f7617fd0fc8a249415ad24b9b808fcfbf1b35ac7fff61fbabab8b7d" => :el_capitan
  end

  depends_on :xcode
  def install
    xcodebuild "-workspace", "slash.xcodeproj/project.xcworkspace", "-derivedDataPath", "prefix.to_s", "-configuration", "Release", "-scheme", "slash", "SYMROOT=#{prefix}/Build"
    bin.install(prefix + "Build/Release/slash")
  end

  test do
    system "false"
  end
end
