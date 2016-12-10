class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.5.0.tar.gz"
  sha256 "a7d9126b4ce7937dbf3c72f14172261ddf59e88f4c2e4b7167601ab3ca421059"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "864602bc1570f7e064b5f1c92e70b01630a5ebd8366a6a4ad4e6dcb56923fa56" => :sierra
    sha256 "38a35d033a7d34d6d190859a867f17cb496f295a5b3b5e2f72a2bdd6002750aa" => :el_capitan
    sha256 "7011475f4a071df76aedd16882a4a91e10c6fe56e82b8eae25797ed6d57582e4" => :yosemite
  end

  option "with-dynamic", "Build dynamic binary with CGO_ENABLED=1"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/hashicorp/nomad").install buildpath.children
    cd "src/github.com/hashicorp/nomad" do
      ENV["CGO_ENABLED"] = "1" if build.with? "dynamic"
      system "go", "build", "-o", bin/"nomad"
      prefix.install_metafiles
    end
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/nomad", "agent", "-dev"
      end
      sleep 10
      ENV.append "NOMAD_ADDR", "http://127.0.0.1:4646"
      system "#{bin}/nomad", "node-status"
    ensure
      Process.kill("TERM", pid)
    end
  end
end
