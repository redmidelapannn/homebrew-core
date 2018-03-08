class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.10.0.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gpgme/gpgme-1.10.0.tar.bz2"
  sha256 "1a8fed1197c3b99c35f403066bb344a26224d292afc048cfdfc4ccd5690a0693"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d02113c679caf0ff6809d68423aa56d8c8959e095a65e21231f47610f35259ba" => :high_sierra
    sha256 "f772db7f84f3e24afb03f79a2506d9783cf4b2e27828aa12ce344e3a76c90318" => :sierra
    sha256 "b0eb26edf46f9f28fc4c818f14ad4cb854f8ad4c9ea551ae1fe17255e743ea8a" => :el_capitan
  end

  depends_on "swig" => :build
  depends_on "gnupg"
  depends_on "libgpg-error"
  depends_on "libassuan"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"gpgme-config", prefix, opt_prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gpgme-tool --lib-version")
    system "python2.7", "-c", "import gpg; print gpg.version.versionstr"
  end
end
