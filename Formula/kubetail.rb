class Kubetail < Formula
  desc "Tail logs from multiple Kubernetes pods at the same time"
  homepage "https://github.com/johanhaleby/kubetail"
  url "https://github.com/johanhaleby/kubetail/archive/1.0.0.tar.gz"
  sha256 "651da64bc3b57c2a9d37dbc4af7e28ddb7903eb3b8965e5efeef0ab6cc97f3e8"

  bottle do
    cellar :any_skip_relocation
    sha256 "42dc4144b730b547da6959f9ab17a83a15c399423de0197248862400fa132c99" => :sierra
    sha256 "42dc4144b730b547da6959f9ab17a83a15c399423de0197248862400fa132c99" => :el_capitan
    sha256 "42dc4144b730b547da6959f9ab17a83a15c399423de0197248862400fa132c99" => :yosemite
  end

  def install
    bin.install "kubetail"
  end

  test do
  end
end
