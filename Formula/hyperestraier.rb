class Hyperestraier < Formula
  desc "Full-text search system for communities"
  homepage "http://fallabs.com/hyperestraier/index.html"
  url "http://fallabs.com/hyperestraier/hyperestraier-1.4.13.tar.gz"
  sha256 "496f21190fa0e0d8c29da4fd22cf5a2ce0c4a1d0bd34ef70f9ec66ff5fbf63e2"

  bottle do
    cellar :any
    rebuild 1
    sha256 "aa3160a27278fdfe8ab4a4b587f669963c9cd1954411890f99355ef94ca37609" => :mojave
    sha256 "7c1d148ddce91f6e4df1cbb41119ba36ea2440094d39ccb0d699a2a5e35a7430" => :high_sierra
    sha256 "0d903292255006427a81a365cd9200c70fa157b54663c1484168a3d58acf3a33" => :sierra
    sha256 "faf960564cd7145295c06451e246f846b5e03b194d4043638b26d9ad47b601c7" => :el_capitan
  end

  depends_on "qdbm"

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make", "mac"
    system "make", "check-mac"
    system "make", "install-mac"
  end

  test do
    system "#{bin}/estcmd", "version"
  end
end
