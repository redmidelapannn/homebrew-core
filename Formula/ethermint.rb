class Ethermint < Formula
  desc "Ethereum powered by Tendermint consensus"
  homepage "https://github.com/tendermint/ethermint"
  url "https://github.com/tendermint/ethermint/archive/v0.5.4.tar.gz"
  sha256 "b571f316841513efa16d8c62c8eeddac3f947af591f964aa3e3b1bb55f10f732"

  bottle do
    cellar :any_skip_relocation
    sha256 "643d89653a5c6a4d6abc1c9609156896c3e883a1ceac892d60ec5e26f591e50b" => :high_sierra
    sha256 "f1436109950a3a802b740abb99f7a3f3b0f35a85b71dda694a9de73bd164dd2f" => :sierra
    sha256 "7328b1433ba3e172b0f1031b40c19b4736dcdd1933203b91cea72f323ed6b60e" => :el_capitan
  end

  head do
    url "https://github.com/tendermint/ethermint.git",
      :branch => "develop"
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ethermintpath = buildpath/"src/github.com/tendermint/ethermint"
    ethermintpath.install buildpath.children
    cd ethermintpath do
      system "make", "get_vendor_deps"
      system "make", "build"
      bin.install "build/ethermint"
    end
  end

  test do
    ethermint_version = shell_output("#{bin}/ethermint version").split("\n").first.partition("  ")[2]
    ethermint_version_without_hash = ethermint_version.partition("-").first
    assert_match version.to_s, ethermint_version_without_hash
  end
end
