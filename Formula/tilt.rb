class Tilt < Formula
  desc "Local Kubernetes development with no stress"
  homepage "https://tilt.build/"
  url "https://github.com/windmilleng/tilt/archive/v0.5.1.tar.gz"
  sha256 "a5f33bbdaca92a7842f5f056fe30260cbb9412deca71634a81596dd981ce5399"

  bottle do
    cellar :any_skip_relocation
    sha256 "e21dc9a566ecbd029370dcbad42da6dba647b9411b82c07a99aa9cba380e1991" => :mojave
    sha256 "010bf3d42b9fc9f7a3780e261b27153d3c9f2ec009cf20f21e1427843f0e2d5c" => :high_sierra
    sha256 "8da1ed0450f1be2a904d320013421b5e30e07887096daaa6a2dbaf769e3a6851" => :sierra
  end

  depends_on "go" => :build
  depends_on "docker"
  depends_on "kubernetes-cli"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"

    (buildpath/"src/github.com/windmilleng").mkpath
    ln_s buildpath, "src/github.com/windmilleng/tilt"

    system "go", "build", "-o", bin/"tilt", "github.com/windmilleng/tilt/cmd/tilt"
    system "go", "build", "-o", bin/"synclet", "github.com/windmilleng/tilt/cmd/synclet"
  end

  test do
    system bin/"tilt", "version"
  end
end
