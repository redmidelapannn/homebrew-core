class GnupgPkcs11Scd < Formula
  desc "Enable the use of PKCS#11 tokens with GnuPG"
  homepage "http://gnupg-pkcs11.sourceforge.net"
  url "https://github.com/alonbl/gnupg-pkcs11-scd/archive/gnupg-pkcs11-scd-0.7.3.tar.gz"
  sha256 "69412cf0a71778026dd9a8adc5276b43e54dc698d12ca36f7f6969d1a76330b8"
  revision 2

  head "https://github.com/alonbl/gnupg-pkcs11-scd.git"

  bottle do
    cellar :any
    sha256 "d9cacdee8efb8ac048b960969d915f09277ae335e07772b06cbc93d1d06bd948" => :el_capitan
    sha256 "d132133e7e9f4a472e7d8d4cb420ae0933d9415dbd097fb5a2eb301e21ab07ab" => :yosemite
    sha256 "0626529265338ef096b94253d970495c937bc66de281accb2839c15361394de5" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libgpg-error"
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "pkcs11-helper"
  depends_on "openssl" => :linked

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--with-libgpg-error-prefix=#{Formula["libgpg-error"].opt_prefix}",
                          "--with-libassuan-prefix=#{Formula["libassuan"].opt_prefix}",
                          "--with-libgcrypt-prefix=#{Formula["libgcrypt"].opt_prefix}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/gnupg-pkcs11-scd --help > /dev/null ; [ $? -eq 1 ]"
  end
end
