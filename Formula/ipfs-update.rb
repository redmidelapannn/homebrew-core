class IpfsUpdate < Formula
  desc "CLI tool to help update and install IPFS easily"
  homepage "https://dist.ipfs.io/#ipfs-update"
  url "https://dist.ipfs.io/ipfs-update/v1.5.2/ipfs-update_v1.5.2_darwin-amd64.tar.gz"
  version "1.5.2"
  sha256 "9f7017fe7453fd42b35a52d631ba4765fdc0e6d0cd890f0eb1a12a64f086c922"

  bottle do
    cellar :any_skip_relocation
    sha256 "2a5e1a50920c3fffbd1050a4bc75881befc6ac3ea04d1687f35cf631c36a134d" => :high_sierra
    sha256 "2a5e1a50920c3fffbd1050a4bc75881befc6ac3ea04d1687f35cf631c36a134d" => :sierra
    sha256 "2a5e1a50920c3fffbd1050a4bc75881befc6ac3ea04d1687f35cf631c36a134d" => :el_capitan
  end

  def install
    bin.install "ipfs-update"
  end

  test do
    system "#{bin}/ipfs-update", "--version"
  end
end
