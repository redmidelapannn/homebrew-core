class PowerlineGo < Formula
  desc "Beautiful and useful low-latency prompt for your shell"
  homepage "https://github.com/justjanne/powerline-go"
  url "https://github.com/justjanne/powerline-go/archive/v1.13.0.tar.gz"
  sha256 "0c0d8a2aca578391edc0120f6cbb61f9ef5571190c07a978932348b0489d00ea"

  bottle do
    cellar :any_skip_relocation
    sha256 "d929303471b5e85d4da65e4b87571bbe2f24a78fe8e674f6b05f82247e9af8f0" => :catalina
    sha256 "24f1f86e30cbb6ecdaf72f861656c96e6ef897037b975e6c385b66677f93c72b" => :mojave
    sha256 "d533c00468bdbcab6818ca1237fadd4e5ce845681fe4965d9f7231ab836090d9" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}"
  end

  test do
    system "#{bin}/#{name}"
  end
end
