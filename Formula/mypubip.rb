
class Mypubip < Formula
  desc ""
  homepage ""
  url "https://github.com/garymalaysia/myPubip/archive/v1.0.1.tar.gz"
  sha256 "0160a676555988b7823debb7116efb579c8999f00c6d5e8387b23b75aa101551"


  bottle do
    cellar :any_skip_relocation
    sha256 "28265204ab250332ca9a2df122dbcd6300cfe5ecc1c8b33dcfe1d1713e067213" => :high_sierra
    sha256 "28265204ab250332ca9a2df122dbcd6300cfe5ecc1c8b33dcfe1d1713e067213" => :sierra
    sha256 "28265204ab250332ca9a2df122dbcd6300cfe5ecc1c8b33dcfe1d1713e067213" => :el_capitan
  end

  def install
      bin.install "myPubip"
  end
end
