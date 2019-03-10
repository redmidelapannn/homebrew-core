class Btfs < Formula
  desc "BitTorrent filesystem based on FUSE"
  homepage "https://github.com/johang/btfs"
  url "https://github.com/johang/btfs/archive/v2.18.tar.gz"
  sha256 "bb9679045540554232eff303fc4f615d28eb4023461eae3f65f08f2427ec9ef2"
  revision 2
  head "https://github.com/johang/btfs.git"

  bottle do
    cellar :any
    sha256 "c143cd021ee62b6ad7c17a46c0e3fea0da04bc63193396ed6e1fea6c79969ab1" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtorrent-rasterbar"
  depends_on :osxfuse

  def install
    ENV.cxx11
    inreplace "configure.ac", "fuse >= 2.8.0", "fuse >= 2.7.3"
    system "autoreconf", "--force", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/btfs", "--help"
  end
end
