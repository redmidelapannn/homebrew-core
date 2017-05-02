class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-2.13.tar.gz"
  sha256 "8cabd676699f281dfa5e840fa1a2f8e000584964a44b99705c4846a8b5221b45"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "698a947f017cf633494505ea7c68291a8dda29166120a66244749b44d848d86d" => :sierra
    sha256 "98c9034b05cca3dcb9160a0dfb24404be75906c81f2ada3e9cfc4ec5287af726" => :el_capitan
    sha256 "ecb437c29506a7ac51838a5483ef7bf7e1db4ace5a90c3e9d179ccd1c6c7bee9" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin

    ln_s buildpath/"dist/src", buildpath/"src"
    system "go", "install", "-v", "github.com/lxc/lxd/lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end
