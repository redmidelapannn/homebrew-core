class Ophcrack < Formula
  desc "Microsoft Windows password cracker using rainbow tables"
  homepage "https://ophcrack.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ophcrack/ophcrack/3.8.0/ophcrack-3.8.0.tar.bz2"
  mirror "https://deb.debian.org/debian/pool/main/o/ophcrack/ophcrack_3.8.0.orig.tar.bz2"
  sha256 "048a6df57983a3a5a31ac7c4ec12df16aa49e652a29676d93d4ef959d50aeee0"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "3acd28c2d88dc42122b5ec537b5db403f0e807329b290ee9b749ef5ad8286254" => :catalina
    sha256 "3217781f774b22eb90d4f45ef44cdf19ee2bb963de020cfa2f771ae9e6ca9352" => :mojave
    sha256 "adc6c9ad1a6ad994ac51abc24537cb8a641c6f99a5bd0dbe1c03622e886018d0" => :high_sierra
  end

  depends_on "openssl@1.1"

  uses_from_macos "expat"

  def install
    system "./configure", "--disable-debug",
                          "--disable-gui",
                          "--with-libssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"ophcrack", "-h"
  end
end
