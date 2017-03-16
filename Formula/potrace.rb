class Potrace < Formula
  desc "Convert bitmaps to vector graphics"
  homepage "https://potrace.sourceforge.io/"
  url "https://potrace.sourceforge.io/download/1.13/potrace-1.13.tar.gz"
  sha256 "6252438b6b6644b9b6298056b4c5de3690a1d4e862b66889abe21eecdf16b784"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a5a2df2e4dca747da1de31c1694bd0cf572e88908cd57b1e8e9dc1071ad74e5c" => :sierra
    sha256 "71919e74ceb26409369f6b5c5d3d55343b86461cad750221a79edc922d2f4d21" => :el_capitan
    sha256 "85d6b47d36ac0df07ca8a986d520382cda3177e31413cce30fce66049f3d85bf" => :yosemite
  end

  resource "head.pbm" do
    url "https://potrace.sourceforge.io/img/head.pbm"
    sha256 "3c8dd6643b43cf006b30a7a5ee9604efab82faa40ac7fbf31d8b907b8814814f"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-libpotrace"
    system "make", "install"
  end

  test do
    resource("head.pbm").stage testpath
    system "#{bin}/potrace", "-o", "test.eps", "head.pbm"
    assert File.exist? "test.eps"
  end
end
