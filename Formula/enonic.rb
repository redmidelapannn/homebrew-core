class Enonic < Formula
  desc "Command-line interface for Enonic XP"
  homepage "https://enonic.com/"
  url "https://repo.enonic.com/public/com/enonic/cli/enonic/0.3/enonic_0.3_Mac_64-bit.tar.gz"
  version "0.3"
  sha256 "cce94ac4999bda7e69be2edadbeebd7f012aed64e9628d3b5681e5a4e0025026"

  bottle do
    cellar :any_skip_relocation
    sha256 "fdf58a7ad67c0c95aa89f9bf19eca34726510ff4cab0396a145866f1b0d33bfe" => :mojave
    sha256 "fdf58a7ad67c0c95aa89f9bf19eca34726510ff4cab0396a145866f1b0d33bfe" => :high_sierra
    sha256 "9668d3cf535c8555574a60a0e4d21f0ecdd61e9c8c2a25acfb02b17df7692088" => :sierra
  end

  def install
    bin.install "enonic"
  end

  test do
    assert_match "Enonic CLI version #{version}", pipe_output("#{bin}/enonic -v")
  end
end
