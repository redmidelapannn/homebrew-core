class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.7.0.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gpgme/gpgme-1.7.0.tar.bz2"
  sha256 "71f55fed0f2b3eaf7a606e59772aa645ce3ffff322d361ce359951b3f755cc48"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ded42844dc8bc014ec3349346a08eb29e35c9aa26b66b37d4702f5c8dddbe54b" => :sierra
    sha256 "2b6ac0a4f3d698aa26deaa46f61244aafc6c54b4defc2a45baf1570b525e1922" => :el_capitan
    sha256 "67e164724c79f3b12dfc75c54b6b54e7e1197f2a92729322093c6764708baad8" => :yosemite
  end

  depends_on "gnupg2"
  depends_on "libgpg-error"
  depends_on "libassuan"
  depends_on "pth"

  fails_with :llvm do
    build 2334
  end

  def install
    # Check these inreplaces with each release.
    # At some point GnuPG will pull the trigger on moving to GPG2 by default.
    inreplace "src/gpgme-config.in" do |s|
      s.gsub! "@GPG@", "#{Formula["gnupg2"].opt_prefix}/bin/gpg"
      s.gsub! "@GPGSM@", "#{Formula["gnupg2"].opt_prefix}/bin/gpgsm"
    end

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
    output = shell_output("#{bin}/gpgme-config --get-gpg").strip
    assert_equal "#{Formula["gnupg2"].opt_prefix}/bin/gpg", output
  end
end
