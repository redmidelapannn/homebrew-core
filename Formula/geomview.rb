class Geomview < Formula
  desc "Interactive 3D viewing program"
  homepage "http://www.geomview.org"
  url "https://deb.debian.org/debian/pool/main/g/geomview/geomview_1.9.5.orig.tar.gz"
  mirror "https://downloads.sourceforge.net/project/geomview/geomview/1.9.5/geomview-1.9.5.tar.gz"
  sha256 "67edb3005a22ed2bf06f0790303ee3f523011ba069c10db8aef263ac1a1b02c0"
  revision 1

  bottle do
    rebuild 1
    sha256 "9596d14588e309cd199a3404988926e3c99e209c5fcfc1c62d4042c38f5b1ae9" => :mojave
    sha256 "89eca9d2365ca1f1e667e6d8b930a85d7a49dce72aa1788aa4e294d78c0982b9" => :high_sierra
  end

  depends_on "openmotif"
  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    (bin/"hvectext").unlink
  end

  test do
    system "#{bin}/geomview", "--version"
  end
end
