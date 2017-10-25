class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/releases/download/v1.9.0/chamber-v1.9.0-darwin-amd64"
  sha256 "723d3ec07ca968f5423b8c7f67a2a5d40e79991f002653c2b3d6cf2784e81154"

  bottle do
    cellar :any_skip_relocation
    sha256 "e26b3ed1233e071c28ee8fc9f9262891250d7bdba76a402dac4ea6d13ae3fe51" => :high_sierra
    sha256 "e26b3ed1233e071c28ee8fc9f9262891250d7bdba76a402dac4ea6d13ae3fe51" => :sierra
    sha256 "e26b3ed1233e071c28ee8fc9f9262891250d7bdba76a402dac4ea6d13ae3fe51" => :el_capitan
  end

  def install
    bin.install Dir["chamber-*"].first => "chamber"
  end

  test do
    system "#{bin}/chamber", "-h"
  end
end
