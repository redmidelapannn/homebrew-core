class Deisctl < Formula
  desc "Deis Control Utility"
  homepage "https://deis.io/"
  url "https://github.com/deis/deis/archive/v1.13.3.tar.gz"
  sha256 "a5b28a7b94e430c4dc3cf3f39459b7c99fc0b80569e14e3defa2194d046316fd"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "05d466d3885ef32196cc60ec4981774963833615a1999b2e0261e67f2f80c3c6" => :sierra
    sha256 "e83100956a790bb5fe2d800afe3a571d5f4da9bad13a6a16d1a13873412e0c6f" => :el_capitan
    sha256 "3604b5d50b4215ac7e7cf32042fd6bea2f5d8e917830cbaf2ee6fd52bbd80e8e" => :yosemite
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/deis").mkpath
    ln_s buildpath, "src/github.com/deis/deis"
    system "godep", "restore"
    system "go", "build", "-o", bin/"deisctl", "deisctl/deisctl.go"
  end

  test do
    system bin/"deisctl", "help"
  end
end
