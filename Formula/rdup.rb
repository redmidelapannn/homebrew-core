class Rdup < Formula
  desc "Utility to create a file list suitable for making backups"
  homepage "https://github.com/miekg/rdup"
  url "https://github.com/miekg/rdup/archive/1.1.15.tar.gz"
  sha256 "787b8c37e88be810a710210a9d9f6966b544b1389a738aadba3903c71e0c29cb"
  revision 2
  head "https://github.com/miekg/rdup.git"

  bottle do
    cellar :any
    sha256 "48cd008738bd8a32a1c531ecbb6963e0bbeb9b6b44676b4fba082231526be684" => :mojave
    sha256 "308da06162bc8e93c36b8ccd29fd05bd4b4fc9f19804590981084404e9ba7fa9" => :high_sierra
    sha256 "23aa35d952a6758a3982d1cb1590438065b1e154113f0cd1de9e091445d152a7" => :sierra
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
