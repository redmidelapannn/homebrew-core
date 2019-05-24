class Termshark < Formula
  desc "Terminal UI for tshark, inspired by Wireshark"
  homepage "https://termshark.io"
  url "https://github.com/gcla/termshark/archive/v1.0.0.tar.gz"
  sha256 "669bba0e8dd7df54ade6321a5c7d2ec20563ffd777f7b3b0394a11f88da64698"

  depends_on "go@1.11" => :build

  def install
    # Don't set GOPATH because we want to build using go modules to
    # ensure our dependencies are the ones specified in go.mod
    ENV["GO111MODULE"] = "on"
    mkdir_p buildpath
    ln_sf buildpath, buildpath/"termshark"

    cd "termshark" do
      system "go", "build", "-o", bin/"termshark", "-ldflags", "-X github.com/gcla/termshark.Version=#{version}", "cmd/termshark/termshark.go"
    end
  end

  test do
    assert_match "termshark v1.0.0", shell_output("#{bin}/termshark -v")
  end
end
