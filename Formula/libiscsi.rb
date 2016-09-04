class Libiscsi < Formula
  desc "Client library and utilities for iscsi"
  homepage "https://github.com/sahlberg/libiscsi"
  url "https://sites.google.com/site/libiscsitarballs/libiscsitarballs/libiscsi-1.17.0.tar.gz"
  sha256 "788cf53f0d8f5f9fb4320da971d2fb49f9830c840bc74ed27cc72b6baa75dec7"
  head "https://github.com/sahlberg/libiscsi.git"

  bottle do
    cellar :any
    sha256 "c3dfb20ce7cc9e12616844d2f4aff31aef9dfdb831a20c1f0cf963d6b9453e05" => :el_capitan
    sha256 "a65aed3f44c8ed81917e339b4aa02f49ef4a64591885ac357d26fc1e85c42d86" => :yosemite
    sha256 "efa1b77699b63a29d1be9c834085d34a56be6c7fadab6587bb367d5223b71779" => :mavericks
    sha256 "a4ad4be9b3da7495606b18c92a38e5c99871672bbc4ddf651fc437ec00aacb0b" => :mountain_lion
  end

  option "with-noinst", "Install the noinst binaries (e.g. iscsi-test-cu)"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "cunit" if build.with? "noinst"
  depends_on "popt"

  def install
    if build.with? "noinst"
      # Install the noinst binaries
      inreplace "Makefile.am", "noinst_PROGRAMS +=", "bin_PROGRAMS +="
    end

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
