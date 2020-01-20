class Wguard < Formula
  desc "Easily Block Websites on macOS"
  homepage "https://github.com/bnwlkr/wguard"
  url "https://github.com/bnwlkr/wguard/archive/v0.1.4.tar.gz"
  sha256 "7560ae8ac9350274be9b8b80fcb2e400a7508826bd6b6adabf5b16ba8cf39087"

  bottle do
    cellar :any_skip_relocation
    sha256 "b715da0de7c76995ce7eed1be4047bbcd6513df6e261696c77de17aa5c3565fe" => :catalina
    sha256 "b715da0de7c76995ce7eed1be4047bbcd6513df6e261696c77de17aa5c3565fe" => :mojave
    sha256 "b715da0de7c76995ce7eed1be4047bbcd6513df6e261696c77de17aa5c3565fe" => :high_sierra
  end

  def install
    bin.install "wguard.py" => "wguard"
  end

  test do
    system bin/"wguard", "-h"
  end
end
