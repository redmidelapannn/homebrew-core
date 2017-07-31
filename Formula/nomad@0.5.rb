class NomadAT05 < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.5.6.tar.gz"
  sha256 "e5f223d6309b7eecd8c3269f4c375ffedf0db8e5a9230b4b287d2de63c461616"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a9e5a71457c5884331f30387a01fe001f0f08fb19bda9398527725daf8779ccd" => :sierra
    sha256 "66c040d1926997de10d4a03e77d403c1db8113ba6c08aa02cecd57c17f03ee32" => :el_capitan
    sha256 "bc2cd57f6c482a14ad430722ac18799ace10e8711ec8761d2666e183c3357cfe" => :yosemite
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
