class SstpClient < Formula
  desc "SSTP (Microsofts Remote Access Solution for PPP over SSL) client"
  homepage "https://sstp-client.sourceforge.io/"
  url "https://iweb.dl.sourceforge.net/project/sstp-client/sstp-client/sstp-client-1.0.12.tar.gz"
  sha256 "487eb406579689803ce0397f6102b18641e4572ac7bc9b9e5f3027c84dcf67ff"

  bottle do
    rebuild 1
    sha256 "d331e3d95ca79203813a75eb9e88828a8aef3bd4d7526ca7f37e458f7a75e0ca" => :high_sierra
    sha256 "ed0997f6d2d74e716a3352e4999fdd301b2fee758c0ba5d9d604fbaea8568030" => :sierra
    sha256 "4236bc20dcf411dd616ecd938140f7a566d9ad75c56a2f945003fc3b9de0092a" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-ppp-plugin",
                          "--prefix=#{prefix}",
                          "--with-runtime-dir=#{var}/run/sstpc"
    system "make", "install"

    # Create a directory needed by sstpc for privilege separation
    (var/"run/sstpc").mkpath
  end

  def caveats; <<~EOS
    sstpc reads PPP configuration options from /etc/ppp/options. If this file
    does not exist yet, type the following command to create it:

    sudo touch /etc/ppp/options
  EOS
  end

  test do
    system "#{sbin}/sstpc", "--version"
  end
end
