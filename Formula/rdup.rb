class Rdup < Formula
  desc "Utility to create a file list suitable for making backups"
  homepage "https://github.com/miekg/rdup"
  url "https://github.com/miekg/rdup/archive/1.1.15.tar.gz"
  sha256 "787b8c37e88be810a710210a9d9f6966b544b1389a738aadba3903c71e0c29cb"
  revision 2
  head "https://github.com/miekg/rdup.git"

  bottle do
    cellar :any
    sha256 "c094fb4c6dda7a5914a44fb398ccd922aacca5d339a835664dac792effa78adf" => :catalina
    sha256 "66a20e233511584d7e7ce3c7bd58307216d7071a035b2399be10369f8c29b747" => :mojave
    sha256 "2352d4fd8e1736617d3edc0d7fbf77fe41d756beaf213379213f08795db317c7" => :high_sierra
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
