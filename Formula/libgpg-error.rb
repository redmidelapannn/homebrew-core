class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.22.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.22.tar.bz2"
  sha256 "f2a04ee6317bdb41a625bea23fdc7f0b5a63fb677f02447c647ed61fb9e69d7b"

  bottle do
    cellar :any
    sha256 "f02dfc60d4bcc662c1b6333cb26f6c79b10ce73f21c255cbeb6778f4a77dc1c4" => :el_capitan
    sha256 "22c014f9ea81569c480fd85d239333169c015c2c4599ecb2b2be1dc29571ac82" => :yosemite
    sha256 "b10110b0b58d35711ca652aef827c504e7a0097768f1735cce2dadfab61f79c2" => :mavericks
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"
  end

  test do
    system "#{bin}/gpg-error-config", "--libs"
  end
end
