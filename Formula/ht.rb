class Ht < Formula
  desc "Viewer/editor/analyzer for executables"
  homepage "https://hte.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/hte/ht-source/ht-2.1.0.tar.bz2"
  sha256 "31f5e8e2ca7f85d40bb18ef518bf1a105a6f602918a0755bc649f3f407b75d70"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e2d9e5271ba7562a0fce9c5bf01eb7b8c59f963fc00ddfcdd8432c611b672a52" => :sierra
    sha256 "12e0754aba66413a48a279b94b964788dfb019f9fdb98c83638b79144f4c2312" => :el_capitan
    sha256 "6fe31fbd356fd32b8144358db692d0e678b63635fd4497ec177f29f96f41f693" => :yosemite
  end

  depends_on "lzo"

  def install
    chmod 0755, "./install-sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-x11-textmode"
    system "make", "install"
  end

  test do
    assert_match "ht #{version}", shell_output("#{bin}/ht -v")
  end
end
