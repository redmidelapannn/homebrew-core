class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  url "https://mirrors.kernel.org/debian/pool/main/s/sane-backends/sane-backends_1.0.27.orig.tar.gz"
  mirror "https://fossies.org/linux/misc/sane-backends-1.0.27.tar.gz"
  sha256 "293747bf37275c424ebb2c833f8588601a60b2f9653945d5a3194875355e36c9"
  revision 4
  head "https://salsa.debian.org/debian/sane-backends.git"

  bottle do
    rebuild 1
    sha256 "36c52568b82fbc36c8eb9b9cafabab314be0387f2129fd572dfc6e4c42a349d2" => :high_sierra
    sha256 "dcb054ce83d073370fcedc64208140aa958371bf9b7125d6b9ccca8c146a2ddf" => :sierra
    sha256 "848f19a49afdf1f3ce5ec2d5bc3be7ed6ad6526db08c49d1baab728cbf6e4798" => :el_capitan
  end

  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libusb"
  depends_on "openssl"
  depends_on "net-snmp"
  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--without-gphoto2",
                          "--enable-local-backends",
                          "--with-usb=yes"

    # Remove for > 1.0.27
    # Workaround for bug in Makefile.am described here:
    # https://lists.alioth.debian.org/pipermail/sane-devel/2017-August/035576.html
    # It's already fixed in commit 519ff57.
    system "make"
    system "make", "install"
  end

  def post_install
    # Some drivers require a lockfile
    (var/"lock/sane").mkpath
  end

  test do
    assert_match prefix.to_s, shell_output("#{bin}/sane-config --prefix")
  end
end
