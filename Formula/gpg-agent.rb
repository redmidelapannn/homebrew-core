# This formula tracks GnuPG stable. You can find GnuPG Modern via:
# brew install homebrew/versions/gnupg21
# At the moment GnuPG Modern causes too many incompatibilities to be in core.
class GpgAgent < Formula
  desc "GPG key agent"
  homepage "https://www.gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.0.30.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnupg/gnupg-2.0.30.tar.bz2"
  sha256 "e329785a4f366ba5d72c2c678a7e388b0892ac8440c2f4e6810042123c235d71"
  revision 1

  bottle do
    rebuild 1
    sha256 "79c0127378404fba28a6556acdde0d8be1a0bccca22884dda31f991e337b244b" => :el_capitan
    sha256 "1620147909d3e59540c2a01bc7acb0103a32dfd65af83e3999e100939399f2fa" => :yosemite
    sha256 "a8b636f54bf5967843a0cb01eb99f74a53d407e2ca753b510d0a1fc208960d81" => :mavericks
  end

  depends_on "libgpg-error"
  depends_on "libgcrypt"
  depends_on "libksba"
  depends_on "libassuan"
  depends_on "pth"
  depends_on "pinentry"

  def install
    ENV.permit_weak_imports
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
                          "--with-scdaemon-pgm=#{Formula["gnupg2"].opt_libexec}/scdaemon"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
      Remember to add "use-standard-socket" to your ~/.gnupg/gpg-agent.conf
      file.
    EOS
  end

  test do
    system "#{bin}/gpg-agent", "--help"
  end
end
