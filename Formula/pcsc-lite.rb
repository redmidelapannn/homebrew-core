class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-1.8.23.tar.bz2"
  sha256 "5a27262586eff39cfd5c19aadc8891dd71c0818d3d629539bd631b958be689c9"

  bottle do
    rebuild 1
    sha256 "4755543b38d1d265492118e3841ac85a51ba6713ae101a0869156b158f39a675" => :high_sierra
    sha256 "63c11204690f566c5b0caa6b08220f809d5b1ce44ec707adf8ab2b1985a2b20d" => :sierra
    sha256 "d4d074a6d9e515729eb9a34de0f0afcd3a092e4d3f286be60d01e65923c27285" => :el_capitan
  end

  keg_only :provided_by_macos,
    "pcsc-lite interferes with detection of macOS's PCSC.framework"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--disable-libsystemd"
    system "make", "install"
  end

  test do
    system sbin/"pcscd", "--version"
  end
end
