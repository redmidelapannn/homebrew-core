class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://gnupg.org/ftp/gcrypt/gpgme/gpgme-1.6.0.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gpgme/gpgme-1.6.0.tar.bz2"
  sha256 "b09de4197ac280b102080e09eaec6211d081efff1963bf7821cf8f4f9916099d"

  bottle do
    cellar :any
    revision 1
    sha256 "d60ef9bae11530bc2700b5b7fa5afe7b405b2e738f7fc105d4c9c188e5fba6cd" => :el_capitan
    sha256 "e37ca8a1b17bbf9d62162d5841f1fe00500a6343679074219b23ede2124ae1f9" => :yosemite
    sha256 "110e9cbe36aa25329cbd412f430e2fd9c2944c8cd05fdf3fb9c4ab9021272308" => :mavericks
  end

  depends_on "gnupg2"
  depends_on "libgpg-error"
  depends_on "libassuan"
  depends_on "pth"

  conflicts_with "argp-standalone",
                 :because => "gpgme picks it up during compile and fails to build"

  fails_with :llvm do
    build 2334
  end

  def install
    # Check these inreplaces with each release.
    # At some point GnuPG will pull the trigger on moving to GPG2 by default.
    inreplace "tests/gpg/Makefile.in", "GPG = gpg", "GPG = gpg2"
    inreplace "src/gpgme-config.in", "@GPG@", "#{Formula["gnupg2"].opt_prefix}/bin/gpg2"
    inreplace "src/gpgme-config.in", "@GPGSM@", "#{Formula["gnupg2"].opt_prefix}/bin/gpgsm"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_equal "#{Formula["gnupg2"].opt_prefix}/bin/gpg2", shell_output("#{bin}/gpgme-config --get-gpg").strip
  end
end
