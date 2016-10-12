class Ctail < Formula
  desc "Tool for operating tail across large clusters of machines"
  homepage "https://github.com/pquerna/ctail"
  url "https://github.com/pquerna/ctail/archive/ctail-0.1.0.tar.gz"
  sha256 "864efb235a5d076167277c9f7812ad5678b477ff9a2e927549ffc19ed95fa911"

  bottle do
    cellar :any
    rebuild 1
    sha256 "420b0e125be3a0d0311439ef8712ee1dd7785ce85256ee7372f8a8b492ac4800" => :sierra
    sha256 "ad50f71bf2eedf0a31c8069b5c837145174bd5ec0c8e16b89347edb74460a966" => :el_capitan
    sha256 "dbdf554370ce2e6e049c042e6f5586c64222ac790d0c9b2074b9ca7db6f1707e" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "apr"
  depends_on "apr-util"

  conflicts_with "byobu", :because => "both install `ctail` binaries"

  def install
    system "./configure",
        "--prefix=#{prefix}",
        "--disable-debug",
        "--with-apr=#{Formula["apr"].opt_bin}",
        "--with-apr-util=#{Formula["apr-util"].opt_bin}"
    system "make", "LIBTOOL=glibtool --tag=CC"
    system "make", "install"
  end

  test do
    system "#{bin}/ctail", "-h"
  end
end
