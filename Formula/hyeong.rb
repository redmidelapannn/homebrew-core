class Hyeong < Formula
  desc "Hyeo-ung Programming Language Compiler in Rust (beta release)"
  homepage "https://github.com/buttercrab/hyeo-ung-lang"
  url "https://github.com/buttercrab/hyeo-ung-lang/releases/download/v0.1.0/hyeong-0.1.0-darwin-x86-64.tar.gz"
  version "0.1.0"
  sha256 "24990f87afe0813a0d67ba6525bc822b73f470c58692b5eedcdb5203dec2aa63"

  bottle do
    cellar :any_skip_relocation
    sha256 "27561631c09eb12508dba69658f9b35bc69cf6a63bcb476e1db92789052ee4fe" => :catalina
    sha256 "27561631c09eb12508dba69658f9b35bc69cf6a63bcb476e1db92789052ee4fe" => :mojave
    sha256 "27561631c09eb12508dba69658f9b35bc69cf6a63bcb476e1db92789052ee4fe" => :high_sierra
  end

  def install
    bin.install "hyeong"
  end

  test do
    assert_match "hyeong 0.1.0", shell_output("#{bin}/hyeong --version")
  end
end
