class Popt < Formula
  desc "Library like getopt(3) with a number of enhancements"
  homepage "https://web.archive.org/web/20190425081726/rpm5.org/"
  url "https://web.archive.org/web/20170922140539/rpm5.org/files/popt/popt-1.16.tar.gz"
  mirror "https://ftp.openbsd.org/pub/OpenBSD/distfiles/popt-1.16.tar.gz"
  sha256 "e728ed296fe9f069a0e005003c3d6b2dde3d9cad453422a10d6558616d304cc8"

  bottle do
    cellar :any
    rebuild 2
    sha256 "e3e96875a6420b31cb5e3642fd4d157dbff084287d4cb686f99f22adbba1af91" => :mojave
    sha256 "8b72bd4a9c1f1392a094ac1112e35e07088b277fbae310a1082a5f60ff368152" => :high_sierra
    sha256 "499505e490070071812848e421cce113a84db5dbe1e7d1e40cef11d36791295a" => :sierra
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
