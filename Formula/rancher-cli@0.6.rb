class RancherCliAT06 < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v0.6.10.tar.gz"
  sha256 "c0039270c0f5ee950628732481e99a84aa2a4a528066a33877774142f5a787ff"

  bottle do
    cellar :any_skip_relocation
    sha256 "a3a93f7f90024cdd4e0700f173d7f8ea70e948c069de9b0e42a50a5125343063" => :high_sierra
    sha256 "2099be81c12aa1eb3db6ebea174f7fded85c909f8934ef73e6d127e0bf34b276" => :sierra
    sha256 "c6010682fe59fcaf6b803c9d6bdaa2c49581c764705e2f90e99bd3c43cdcfdb4" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/rancher/cli/").install Dir["*"]
    system "go", "build", "-ldflags",
           "-w -X github.com/rancher/cli/version.VERSION=#{version}",
           "-o", "#{bin}/rancher",
           "-v", "github.com/rancher/cli/"
  end

  test do
    system bin/"rancher", "help"
  end
end
