class Swamp < Formula
  desc "AWS Profile Manager. You can use swamp to switch profiles with ease"
  homepage "https://github.com/felixb/swamp"
  url "https://github.com/felixb/swamp/archive/v0.10.0.tar.gz"
  sha256 "4cdcdd3e7b9085de5c0f53a9783e3392680727372d89f0e38270ab8da889b1d8"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4f86ab48c0b226a2f187467d94b5bc91556b97fb2ee4305762bad00a17d780d" => :mojave
    sha256 "15504457ac1edc81be5bf10be5dce6e071e123ebc9a36ffbacf92bbf5a6b9726" => :high_sierra
    sha256 "9a1fabd8962eef0b60f578b83088040777d4d088929e18d890c4361af17dd70c" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    bin_path = buildpath/"src/github.com/felixb/swamp"

    bin_path.install Dir["*"]

    cd bin_path do
      system "make", "swamp_darwin"
      mv "swamp_darwin", "swamp"
      bin.install "swamp"
    end
  end

  test do
    assert_match /swamp:\ 0.10.0/, shell_output("#{bin}/swamp 2>&1", 1)
  end
end
