class K2cli < Formula
  desc "CLI for K2"
  homepage "https://github.com/samsung-cnct/k2cli"
  url "https://github.com/samsung-cnct/k2cli/releases/download/1.0.5/k2cli_1.0.5_darwin_amd64.tar.gz"
  sha256 "7e5c0fcd1a696cdbdf0c9bab0035e1c6b336b3b8d81ad7d568fbe54743d67a55"

  bottle do
    cellar :any_skip_relocation
    sha256 "11c35a8714a577b60f8570b73d2466ddbf7b3d5c7659b5e49f5611f102c3f960" => :sierra
    sha256 "572ec3d377eb74110d58d35bd304d614d5c3499e458a01ff294ab82f0c991efd" => :el_capitan
    sha256 "572ec3d377eb74110d58d35bd304d614d5c3499e458a01ff294ab82f0c991efd" => :yosemite
  end

  depends_on "docker" => :run

  def install
    bin.install "k2cli"
  end

  test do
    # test that we can generate a config file.
    system bin/"k2cli", "generate", (testpath/"config.yaml")
  end
end
