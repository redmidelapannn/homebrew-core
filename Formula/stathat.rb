class Stathat < Formula
  desc "Command-line interface to stathat.com"
  homepage "https://stathat.com"
  url "https://github.com/stathat/cmd/archive/v0.2.0.tar.gz"
  sha256 "f3771dac0394d15f670ab3073e09d1596b0d490cba99946e8631a3917144834a"

  head "https://github.com/stathat/cmd.git"

  bottle do
    sha256 "d24235651a0584eb84c1ef7a14db1e5de77341bfb0dc28c6e7e5181956c5a5f3" => :sierra
    sha256 "d8165a8fc0c69b3d80759a0148b97fd6efd1505cb15b7cfeff6c3978c31ff598" => :el_capitan
    sha256 "fe132d054526faa5d6c40311c5961bf265e7c5ad5d4edf54d735e04c2004fca3" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = buildpath
    (buildpath/"src/github.com/stathat/cmd/").install "stathat"

    system "go", "build", "-a", "github.com/stathat/cmd/stathat"
    bin.install "stathat"
  end

  test do
    system "#{bin}/stathat", "version"
  end
end
