class Mole < Formula
  desc "App to create ssh tunnels"
  homepage "https://davrodpin.github.io/mole/"
  url "https://github.com/davrodpin/mole/archive/v0.1.0.tar.gz"
  sha256 "0e9d1cdd87069672a037bf82cde08a9e5d7fedfcb4b3f3093996fe2862892c46"

  bottle do
    cellar :any_skip_relocation
    sha256 "1fb6d3be01e20ada63c41cf41c68838bbca14a05e582e85bd68fe88bf3c8df69" => :mojave
    sha256 "bbf77cc669eb1702f73a248838141e1bdf86bbcbaef5d5a7e895aaa3d875db8d" => :high_sierra
    sha256 "2026e343285eb88740d2b91a85fc790590146f3814048515b5329622322e3569" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    bin_path = buildpath/"src/github.com/davrodpin/mole"
    bin_path.install Dir["*"]

    cd bin_path do
      system "go", "build", "-o", bin/"mole", "-ldflags", "-X main.version=0.1.0", "github.com/davrodpin/mole/cmd/mole"
    end
  end

  test do
    assert_match "mole 0.1.0", shell_output("#{bin}/mole -version 2>&1", 2)
  end
end
