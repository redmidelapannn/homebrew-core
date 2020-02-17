class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.13.1.tar.bz2"
  sha256 "c4e30b227682374c23cddc7fdb9324a99694d907e79242a25a4deeedb393be46"

  bottle do
    cellar :any
    rebuild 2
    sha256 "515b8182a1d09912e78575e88213786b52aaf23709c6635e15ee5dc4e295e01d" => :catalina
    sha256 "97af117dc5f005d5899e501efb26c61260dede634ee3cdab47445bdbd85c61e5" => :mojave
    sha256 "abc14ed89dd412bc8a4700d8edaa409c2af4d0ef580e9cf41ad356c59687a618" => :high_sierra
  end

  depends_on "python" => [:build, :test]
  depends_on "swig" => :build
  depends_on "gnupg"
  depends_on "libassuan"
  depends_on "libgpg-error"

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
    system "python3", "-c", "import gpg; print(gpg.version.versionstr)"
  end
end
