class GpgAgent < Formula
  desc "GPG key agent"
  homepage "https://www.gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.0.30.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnupg/gnupg-2.0.30.tar.bz2"
  sha256 "e329785a4f366ba5d72c2c678a7e388b0892ac8440c2f4e6810042123c235d71"
  revision 3

  bottle do
    rebuild 1
    sha256 "3cb8b9cb1f5738320fec366a9a2477e623994789fe1ece9927ab52a23696ea6e" => :sierra
    sha256 "de77e44d9a7f6c72e71572d97a132e10418511d05284d4480906440ea922e244" => :el_capitan
    sha256 "4acd296b11be12fa89af9d64408f58730b97c4748b2fac06f96d628a5f5dde92" => :yosemite
  end

  keg_only "GPG 2.1.x ships an internal gpg-agent which it must use"

  depends_on "libgpg-error"
  depends_on "libgcrypt"
  depends_on "libksba"
  depends_on "libassuan"
  depends_on "pth"
  depends_on "pinentry"

  def install
    # don't use Clang's internal stdint.h
    ENV["gl_cv_absolute_stdint_h"] = "#{MacOS.sdk_path}/usr/include/stdint.h"

    # Adjust package name to fit our scheme of packaging both
    # gnupg 1.x and 2.x, and gpg-agent separately
    inreplace "configure" do |s|
      s.gsub! "PACKAGE_NAME='gnupg'", "PACKAGE_NAME='gpg-agent'"
      s.gsub! "PACKAGE_TARNAME='gnupg'", "PACKAGE_TARNAME='gpg-agent'"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-agent-only",
                          "--with-pinentry-pgm=#{Formula["pinentry"].opt_bin}/pinentry",
                          "--with-scdaemon-pgm=#{Formula["gnupg@2.0"].opt_libexec}/scdaemon"
    system "make", "install"
  end

  test do
    system "#{bin}/gpg-agent", "--help"
  end
end
