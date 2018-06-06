class Pinfo < Formula
  desc "User-friendly, console-based viewer for Info documents"
  homepage "https://packages.debian.org/sid/pinfo"
  url "https://mirrorservice.org/sites/distfiles.macports.org/pinfo/pinfo-0.6.10.tar.bz2"
  sha256 "122180a0c23d11bc9eb569a4de3ff97d3052af96e32466fa62f2daf46ff61c5d"

  bottle do
    rebuild 1
    sha256 "dfd1464ee40423268926c76b921b441e0c47b621848276e7822fbd209d04bf17" => :high_sierra
    sha256 "4e98ae3352127fe507a0b3a32bb1749ecfd3bb1387e52fa581d02c1a43eb6c42" => :sierra
    sha256 "1dc2e3535c023f94a93f18c73bf3ce1bf313c37f63a16de1e86b121fd21b4237" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "gettext"
  depends_on "readline" => :optional

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/pinfo", "-h"
  end
end
