class Rdup < Formula
  desc "Utility to create a file list suitable for making backups"
  homepage "https://github.com/miekg/rdup"
  url "https://github.com/miekg/rdup/archive/1.1.15.tar.gz"
  sha256 "787b8c37e88be810a710210a9d9f6966b544b1389a738aadba3903c71e0c29cb"
  revision 2
  head "https://github.com/miekg/rdup.git"

  bottle do
    cellar :any
    sha256 "c3b627dfd5ea236199b8a681011bc75a4df2afa3146e71bf88e77140c85c9873" => :catalina
    sha256 "89b2ad3c4f772d6396ff940c90999a2237a829a32a8fe455765c533a063fdfbe" => :mojave
    sha256 "c3da0698c4451ed0221dc7abb6bb2738e47ea2d3ee41cbf23034c62efc1fdecc" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libarchive"
  depends_on "mcrypt"
  depends_on "nettle"
  depends_on "pcre"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    # tell rdup to archive itself, then let rdup-tr make a tar archive of it,
    # and test with tar and grep whether the resulting tar archive actually
    # contains rdup
    system "#{bin}/rdup /dev/null #{bin}/rdup | #{bin}/rdup-tr -O tar | tar tvf - | grep #{bin}/rdup"
  end
end
