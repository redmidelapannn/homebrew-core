class BbftpClient < Formula
  desc "Secure file transfer software, optimized for large files"
  # http://doc.in2p3.fr/bbftp/ is 404
  # Contacted bbftp AT in2p3 DOT fr and mirror AT cc.in2p3 DOT fr 18 Sep 2017
  homepage "https://web.archive.org/web/20170722062740/http://doc.in2p3.fr/bbftp/"
  # http://doc.in2p3.fr/bbftp/dist/bbftp-client-3.2.1.tar.gz is 404
  url "http://ftp.riken.jp/net/bbftp/bbftp-client-3.2.1.tar.gz"
  mirror "ftp://ccpntc11.in2p3.fr/pub/bbftp/bbftp-client-3.2.1.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/bbftp-client-3.2.1.tar.gz"
  sha256 "4000009804d90926ad3c0e770099874084fb49013e8b0770b82678462304456d"
  revision 1

  bottle do
    rebuild 1
    sha256 "91e76f175d01aa1b155cd3f5e7e0ebd7a92c3f052ed470cfb676fce90ced1c34" => :sierra
    sha256 "174e9769ccce98f3bc6d592d5e2a19aea83e76fd5743f380124c4373e8430191" => :el_capitan
  end

  depends_on "openssl"

  def install
    # Fix ntohll errors; reported 14 Jan 2015.
    ENV.append_to_cflags "-DHAVE_NTOHLL" if MacOS.version >= :yosemite

    cd "bbftpc" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--with-ssl=#{Formula["openssl"].opt_prefix}", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/bbftp", "-v"
  end
end
