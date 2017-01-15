class Libiscsi < Formula
  desc "Client library and utilities for iscsi"
  homepage "https://github.com/sahlberg/libiscsi"
  url "https://sites.google.com/site/libiscsitarballs/libiscsitarballs/libiscsi-1.18.0.tar.gz"
  sha256 "367ad1514d1640e4e72ca6754275ec226650a128ca108f61a86d766c94d63d23"
  head "https://github.com/sahlberg/libiscsi.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "13100e29ea9221f833aef4fc84136eba9a3e7b6391b253004f76a10fd51d688f" => :sierra
    sha256 "fa3a6c28902ccfea3ac8e09bff6f8f50f8d4a1539dd69af6e9d8211170489b21" => :el_capitan
    sha256 "dfba363533b4f6fadace06e967013471b07110e86b7a98a0e3cd1bebe7e3df04" => :yosemite
  end

  option "with-noinst", "Install the noinst binaries (examples, tests)"
  option "with-cunit", "Install iscsi-test-cu, the iSCSI target test suite"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "cunit" => :optional

  def install
    if build.without? "cunit"
      inreplace "test-tool/Makefile.am", "bin_PROGRAMS =", "noinst_PROGRAMS ="
    end
    if build.with? "noinst"
      # Install the noinst binaries
      inreplace ["tests/Makefile.am", "examples/Makefile.am"], "noinst_PROGRAMS =", "bin_PROGRAMS ="
    end

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"iscsi-ls", "--usage"
    if build.with? "cunit"
      system bin/"iscsi-test-cu", "--list"
    end
    if build.with? "noinst"
      system bin/"prog_noop_reply", "--usage"
    end
  end
end
