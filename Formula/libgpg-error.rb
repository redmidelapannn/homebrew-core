class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.26.tar.bz2"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/libg/libgpg-error/libgpg-error_1.26.orig.tar.bz2"
  sha256 "4c4bcbc90116932e3acd37b37812d8653b1b189c1904985898e860af818aee69"

  bottle do
    rebuild 1
    sha256 "1bf505a8697d0f313ce3dca1bd65d71c6044c049270e50b54c3232501eabd7d1" => :sierra
    sha256 "7b47398fa79fbf99ec79deb0fa713727c04ce9e4f94c189c1bcb900ff52cc55e" => :el_capitan
    sha256 "4e2bcb8618342864efe0b54481573048c031be70980300edee4a2698e82b6478" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"gpg-error-config", prefix, opt_prefix
  end

  test do
    system "#{bin}/gpg-error-config", "--libs"
  end
end
