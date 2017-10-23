class Cvc4 < Formula
  desc "Efficient automated theorem prover for SMT problems."
  homepage "https://cvc4.cs.stanford.edu/web/"
  url "https://cvc4.cs.stanford.edu/downloads/builds/x86_64-macos-opt/cvc4-1.5-x86_64-macos-10.12-opt"
  version "1.5"
  sha256 "70f7673eb8243c612925e0f20456dd0e639e8a96ecb1c165c22e4b8600a030d2"

  bottle do
    cellar :any
    sha256 "565da883bb8106f0808a76ab90097ece30af6a73b35c85f852eb300d3efbb139" => :high_sierra
    sha256 "932f1951e0d48c0f7a1d83062469a259ec38dbe84237d6a8fba26466ee98c180" => :sierra
    sha256 "932f1951e0d48c0f7a1d83062469a259ec38dbe84237d6a8fba26466ee98c180" => :el_capitan
  end

  def install
    mv "cvc4-1.5-x86_64-macos-10.12-opt", "cvc4-1.5"
    bin.install "cvc4-1.5"
  end

  test do
    system "false"
  end
end
