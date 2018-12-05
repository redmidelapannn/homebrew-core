class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools.git",
      :tag      => "0.19.2.1",
      :revision => "3f6a2256863cb60d56b63b883dc797225b888e15"

  bottle do
    cellar :any_skip_relocation
    sha256 "d448aad03e9005dd7e40bf8ffbb370fece238438a538f8b81838878e803b352f" => :mojave
    sha256 "d9ffca741c934667cf02c8e83309fae2850451b4f9d87cfc50d628d0594c0f71" => :high_sierra
    sha256 "bcb0dd5f5834bf568e9f1347b0a59dc8b1d24c86e7efa543150569c964f3cc87" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/bazelbuild").mkpath
    ln_sf buildpath, buildpath/"src/github.com/bazelbuild/buildtools"

    commit = Utils.popen_read("git", "rev-parse", "HEAD").chomp
    inreplace "buildifier/buildifier.go" do |s|
      s.gsub! /^(var buildVersion = ")redacted/, "\\1#{version}"
      s.gsub! /^(var buildScmRevision = ")redacted/, "\\1#{commit}"
    end

    system "go", "get", "github.com/golang/protobuf/proto"
    system "go", "build", "-o", bin/"buildifier", "buildifier/buildifier.go"
  end

  test do
    touch testpath/"BUILD"
    system "#{bin}/buildifier", "-mode=check", "BUILD"
  end
end
