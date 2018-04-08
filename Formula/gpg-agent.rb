class GpgAgent < Formula
  desc "GPG key agent"
  homepage "https://www.gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.2.5.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnupg/gnupg-2.2.5.tar.bz2"
  sha256 "3fa189a32d4fb62147874eb1389047c267d9ba088f57ab521cb0df46f08aef57"

  bottle do
    sha256 "483be6b6324459690101e200831c4b5e95295bf60fd24cdab37c3793d038160e" => :high_sierra
    sha256 "88b7fe07d4e8f6445acf9bbb0a5c08fd01c9387eae405d70b7e522de7949804e" => :sierra
    sha256 "7fde8ecb77af4c724f9226c604a456199c16e82dd76815312569b149aa9ddf7c" => :el_capitan
  end

  keg_only "GPG 2.1.x ships an internal gpg-agent which it must use"

  depends_on "libgpg-error"
  depends_on "libgcrypt"
  depends_on "libksba"
  depends_on "libassuan"
  depends_on "libusb"
  depends_on "npth"
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
    system "make", "CC=#{ENV.cc}",
                   "LIBUSB_CFLAGS=-I#{Formula["libusb"].opt_include}/libusb-1.0"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Remember to add "use-standard-socket" to your ~/.gnupg/gpg-agent.conf
      file.
    EOS
  end

  test do
    system "#{bin}/gpg-agent", "--help"
  end
end
