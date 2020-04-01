class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.0.0.tar.gz"
  sha256 "cbe2ba49bb40c4497ac76b45f6a4993ea432e41f18d4a3d2b3ef69afcc6d7e02"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee82f9fc5e9c195a4e84553525ea746f957f23e23ff0fd02d5c6936f4166ae5d" => :catalina
    sha256 "72f0547691f95eae99c5aa30e9d79c26a1ed997ed5432ef39483d4b2bdc25612" => :mojave
    sha256 "f6274c6870cf19e165939b55e960c351933b7e0994a6128cb6596ffaf91375e9" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin

    ln_s buildpath/"_dist/src", buildpath/"src"
    system "go", "install", "-v", "github.com/lxc/lxd/lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end
