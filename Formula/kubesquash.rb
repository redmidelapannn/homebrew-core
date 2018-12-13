class Kubesquash < Formula
  desc "Debugger for Kubernetes applications"
  homepage "https://github.com/solo-io/kubesquash"
  url "https://github.com/solo-io/kubesquash/releases/download/v0.1.6/kubesquash-osx"
  version "0.1.6"
  sha256 "acfd077d186202e4fd88ec6c96aa26130d86b2e6eae308ff7b000cc307ab1b2c"

  bottle do
    cellar :any_skip_relocation
    sha256 "91557a2ad5dc07105551f897cecea70d4418df5e0893c2593d8e16fd70870b4c" => :mojave
    sha256 "2b81bc5f650c6f1e6a30e873bc63cd54cbcf49f1cc110a3f16eed885313a7d98" => :high_sierra
    sha256 "2b81bc5f650c6f1e6a30e873bc63cd54cbcf49f1cc110a3f16eed885313a7d98" => :sierra
  end

  def install
    mv "kubesquash-osx", "kubesquash"
    bin.install "kubesquash"
  end

  test do
    system "#{bin}/kubesquash", "--help"
  end
end
