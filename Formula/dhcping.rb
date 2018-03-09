class Dhcping < Formula
  desc "Perform a dhcp-request to check whether a dhcp-server is running"
  homepage "https://www.mavetju.org/unix/general.php"
  url "https://www.mavetju.org/download/dhcping-1.2.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/d/dhcping/dhcping_1.2.orig.tar.gz"
  sha256 "32ef86959b0bdce4b33d4b2b216eee7148f7de7037ced81b2116210bc7d3646a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b143ee39e9b3b0c2c2cdbebb7e569375f9524ec7b88ea4f02e0f8effb50f0020" => :high_sierra
    sha256 "41f36117da13bdd4642662c1737128cd4c9e0de5b9f97d80425dc68a8b2ff20a" => :sierra
    sha256 "b54a135b1a02fa4a38d3d4f9b45cea8a1257f7a48e5c8621af81d2851f37ea71" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end
end
