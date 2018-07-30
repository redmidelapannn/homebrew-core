class Dvorak7min < Formula
  desc "Dvorak (simplified keyboard layout) typing tutor"
  homepage "https://web.archive.org/web/dvorak7min.sourcearchive.com/"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/dvorak7min/dvorak7min_1.6.1+repack.orig.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/d/dvorak7min/dvorak7min_1.6.1+repack.orig.tar.gz"
  version "1.6.1"
  sha256 "4cdef8e4c8c74c28dacd185d1062bfa752a58447772627aded9ac0c87a3b8797"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "5f4075ac60a7bfbaf7c6c0a3a9da237264b80801572de905018749fc72a2e56d" => :high_sierra
    sha256 "a91fbd34a3d50f59999350155f19284bac6eedc7b17924e3b3360bcccfa10aed" => :sierra
    sha256 "48a665aa41d4b3e6cd3fede5421805041085d4d2d3dbd3f61caf653618da6a86" => :el_capitan
  end

  def install
    # Remove pre-built ELF binary first
    system "make", "clean"
    system "make"
    system "make", "INSTALL=#{bin}", "install"
  end
end
