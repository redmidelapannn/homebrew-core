class Testdisk < Formula
  desc "Powerful free data recovery utility"
  homepage "https://www.cgsecurity.org/wiki/TestDisk"
  url "https://www.cgsecurity.org/testdisk-7.0.tar.bz2"
  sha256 "00bb3b6b22e6aba88580eeb887037aef026968c21a87b5f906c6652cbee3442d"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "3778b6ebff612b861edb50bf40f708553bdad03e3ed3f5e31d38295936239b3e" => :el_capitan
    sha256 "dbbb8d33ab41d8d20bb35f96531dd2f2acaf01c4dff610df374f2ffd0a044a45" => :yosemite
    sha256 "feda5e41b9c1f336217ac54d3296baff094d2194038031a907bb379045638eb3" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = "test.dmg"
    system "hdiutil", "create", "-megabytes", "10", path
    system "#{bin}/testdisk", "/list", path
  end
end
