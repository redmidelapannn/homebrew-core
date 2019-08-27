class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.9.5.tar.gz"
  sha256 "f5dcc802cd07756f169c24dda637fe32f8b2cb6c6bb71bb2b3f4d7f3def8223b"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "df3c7d241c347152c284b8f95de31b026f0d111d64723da87d9e2d8a867ed3be" => :mojave
    sha256 "b1af3898c280e711532876cf50f96017ba74970834583b92a1b4c077a3c4c4d8" => :high_sierra
    sha256 "82b726591162982a3d467b48f33294f35d88764c20cba59ca8b6cf353cb96a51" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    src = buildpath/"src/github.com/hashicorp/nomad"
    src.install buildpath.children
    src.cd do
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
