class Rdup < Formula
  desc "Utility to create a file list suitable for making backups"
  homepage "https://github.com/miekg/rdup"
  url "https://github.com/miekg/rdup/archive/1.1.15.tar.gz"
  sha256 "787b8c37e88be810a710210a9d9f6966b544b1389a738aadba3903c71e0c29cb"
  head "https://github.com/miekg/rdup.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e3043e6b39f95f70208fdf6f498990c8ab70b0e74180c7c8e7d500edcc88b30c" => :mojave
    sha256 "ea28df7b2ad7ee2c343b2e18f1339d4bfcb61010956a740837df636a6f4bd03a" => :high_sierra
    sha256 "e1d155ed13f5c8676e08171e21a0bf54d3abda0d4a9dee7c1e27c1b5401f3c91" => :sierra
    sha256 "d0644ae5e23551c75d33c0834267824285f654c0bdb061ce6fdec150d3790ce2" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "nettle"
  depends_on "pcre"
  depends_on "glib"
  depends_on "libarchive"
  depends_on "mcrypt"

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
