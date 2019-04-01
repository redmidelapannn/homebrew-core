class Kubetail < Formula
  desc "Tail logs from multiple Kubernetes pods at the same time"
  homepage "https://github.com/johanhaleby/kubetail"
  url "https://github.com/johanhaleby/kubetail/archive/1.6.8.tar.gz"
  sha256 "c6c7ffa54d6f5d28b8c3fa6a6a505827f0a0d4887d8376d6fc605b1bf7c8ae64"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c0c5893f94c56b8b1fbe5cd8f0b1a4cc485716e6a7de24cb1e8ffb9355cb172" => :mojave
    sha256 "3c0c5893f94c56b8b1fbe5cd8f0b1a4cc485716e6a7de24cb1e8ffb9355cb172" => :high_sierra
    sha256 "d0ab1023585aed90d40d364e9f11ef602bdd39ddef9cc496856248c449b3ee68" => :sierra
  end

  def install
    bin.install "kubetail"
  end

  test do
    system bin/"kubetail", "--version"
  end
end
