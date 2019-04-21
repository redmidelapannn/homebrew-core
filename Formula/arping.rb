class Arping < Formula
  desc "Utility to check whether MAC addresses are already taken on a LAN"
  homepage "https://github.com/ThomasHabets/arping"
  url "https://github.com/ThomasHabets/arping/archive/arping-2.19.tar.gz"
  sha256 "b1477892e19687a99fa4fb42e147d7478d96d0d3fc78ca4faade6392452414db"
  revision 1

  bottle do
    cellar :any
    sha256 "7fd8a34b8e3f7b1b0d42563dec2cf885df140339bd0a4d187861938881ad978a" => :mojave
    sha256 "43b1a7e5b8f231d63ed44b78002796920ab721c7196675bd77950775f84404b4" => :high_sierra
    sha256 "f157c93487e42e9729b11bea75504132efe00ecb7a77842605a02df1864a2783" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libnet"

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
