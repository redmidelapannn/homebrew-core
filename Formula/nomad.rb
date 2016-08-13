class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.4.0.tar.gz"
  sha256 "b9098781812b93a77ffdfadecd0d3fc8fd5f73dce4b48cd76495b0124bd8cfe5"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "b10ca1e1e43aee01dd7b2150a9b154805beb3097c2321a02105d735f6b601ffc" => :el_capitan
    sha256 "6ee0dd92a8834b4b05a5ea256cb5f96f4f2da6485b9721b3de6a2ac496a9a339" => :yosemite
    sha256 "8b9e87d4e04a348791aad13de19c1748d34750fb5a3ffeb748319f4e4c7b135d" => :mavericks
  end

  devel do
    url "https://github.com/hashicorp/nomad/archive/v0.4.1-rc1.tar.gz"
    version "0.4.1-rc1"
    sha256 "b9883930003283c0dbc0027b273ce5ae745055c542d2fe514befcd4d555d89cb"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/hashicorp/nomad").install buildpath.children
    cd "src/github.com/hashicorp/nomad" do
      system "go", "build", "-o", bin/"nomad"
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
