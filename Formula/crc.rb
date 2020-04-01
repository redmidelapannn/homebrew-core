class Crc < Formula
  desc "OpenShift 4 cluster on your local machine"
  homepage "https://code-ready.github.io/crc/"
  url "https://github.com/code-ready/crc.git",
      :tag      => "1.8.0",
      :revision => "0a318dc9335a1e7cc24c5b19b5aa383ec619f9c4"
  head "https://github.com/code-ready/crc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "089f249a31a6af3643f1de2b2744858e7a23537e3563cd44de5a262bf91b0135" => :catalina
    sha256 "477c0ebe593700672651c43cfcc55975e3ce88f5568a7264e12127a80c396947" => :mojave
    sha256 "dcc1c523e92b6e0c85187b92f8c23f11479fa7987926a6e8e37ac378e11f7592" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "out/macos-amd64/crc"
    bin.install "out/macos-amd64/crc"
  end

  test do
    assert_match /^crc version: #{version}/, shell_output("#{bin}/crc version")

    # Should error out as running crc requires root
    status_output = shell_output("#{bin}/crc setup 2>&1", 1)
    assert_match "Unable to set ownership", status_output
  end
end
