class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.8.1.tar.gz"
  sha256 "b1d5621a2c5e2acf94a1098b7baa5502964059c225f160158b5af07aaf2889a7"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "09bbe241c985e1a0615c0feeceda5116dc6f63f39c2347fe09aa971d1078bdbc" => :high_sierra
    sha256 "5e0d83054de0e7fccbff8d3a8322ebc73fd741d63dbcb9056a94af30a7265b05" => :sierra
    sha256 "58c2cbdece325b373dce64d7cbee0ef51b1b270020e55e0f3a3f4e9557e8e719" => :el_capitan
  end

  option "with-dynamic", "Build dynamic binary with CGO_ENABLED=1"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/hashicorp/nomad").install buildpath.children
    cd "src/github.com/hashicorp/nomad" do
      ENV["CGO_ENABLED"] = "1" if build.with? "dynamic"
      system "go", "build", "-tags", "ui", "-o", bin/"nomad"
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
