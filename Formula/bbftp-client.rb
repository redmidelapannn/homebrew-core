class BbftpClient < Formula
  desc "Secure file transfer software, optimized for large files"
  homepage "http://doc.in2p3.fr/bbftp/"
  url "http://doc.in2p3.fr/bbftp/dist/bbftp-client-3.2.1.tar.gz"
  mirror "https://ftp.riken.jp/net/bbftp/bbftp-client-3.2.1.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/bbftp-client-3.2.1.tar.gz"
  sha256 "4000009804d90926ad3c0e770099874084fb49013e8b0770b82678462304456d"
  revision 1

  bottle do
    rebuild 1
    sha256 "b4e40b42370f692dfc4e1668e88c4c0d5dce67f224c9da7c1c345d3ace3e5d1e" => :high_sierra
    sha256 "05ef262cb5e54ec7999f71881e52115fcaf95250490a83a8842a18eec98e3c16" => :sierra
    sha256 "00a5f700b688b5e8824af5e8d85c7d8b12414784cc16e5af44b6d1d5f938e83f" => :el_capitan
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
