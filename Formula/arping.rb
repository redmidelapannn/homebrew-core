class Arping < Formula
  desc "Utility to check whether MAC addresses are already taken on a LAN"
  homepage "https://github.com/ThomasHabets/arping"
  url "https://github.com/ThomasHabets/arping/archive/arping-2.19.tar.gz"
  sha256 "b1477892e19687a99fa4fb42e147d7478d96d0d3fc78ca4faade6392452414db"

  bottle do
    cellar :any
    rebuild 1
    sha256 "13b99429413dbb10d804557111e8d1ac1d5b23284a98d1a8c349b56726f85ba3" => :mojave
    sha256 "92423c2ec66e46f1aa49922bcbaf4c61e40a2491b7c40914806cddb9c039e88a" => :high_sierra
    sha256 "fad0ca41c820ac7129758b5c40ac3d8afddb26c00a55bba0d520d81abfc85aec" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libnet"
  uses_from_macos "libpcap"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/arping", "--help"
  end
end
