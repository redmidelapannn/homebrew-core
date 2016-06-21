class Libmtp < Formula
  desc "Implementation of Microsoft's Media Transfer Protocol (MTP)"
  homepage "http://libmtp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/libmtp/libmtp/1.1.10/libmtp-1.1.10.tar.gz"
  sha256 "1eee8d4c052fe29e58a408fedc08a532e28626fa3e232157abd8fca063c90305"

  bottle do
    cellar :any
    revision 1
    sha256 "999758e63e253f752292bd63c5950b531bcb6dcee2c57479ac66cce39d507954" => :el_capitan
    sha256 "5b59b526a604c650309f79fd1674fa1de1fa7d2ca7512f1cb700d3988a4565de" => :yosemite
    sha256 "2927497ebd36caccb2c67a1ad27d72f47e3a4b88bb5284289d4353004a84a760" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-mtpz"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mtp-getfile")
  end
end
