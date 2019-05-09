class Vcn < Formula
  desc "VChain Code Notary Command-Line Interface"
  homepage "https://www.codenotary.io"
  url "https://github.com/vchain-us/vcn/archive/0.4.1.tar.gz"
  sha256 "4a811b0832c5d7ea086bdfd13ca0b30d966d4195aac10eae5b17c4b98d7f3116"

  bottle do
    cellar :any_skip_relocation
    sha256 "7fc0d3747a0888a5c731f60771dc927c7d00a692cd3a5b58e457d216308ee09f" => :mojave
    sha256 "cbf54220b9a67ef8bc7017b2b34cf65fbeaeb2405458fa4f3d47e2a3e9180e4c" => :high_sierra
    sha256 "43dda65f894bebdecc2b06a63a927cf34ad0fd7ebc7e99681bfdac8e8cd91344" => :sierra
  end

  head do
    url "https://github.com/vchain-us/vcn.git"
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = buildpath
    system "make", "install"
    bin.install "./vcn" => "vcn"
  end

  test do
    system "#{bin}/vcn", "--help"
  end
end
