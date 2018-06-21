class SstpClient < Formula
  desc "SSTP (Microsofts Remote Access Solution for PPP over SSL) client"
  homepage "https://sstp-client.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sstp-client/sstp-client/sstp-client-1.0.12.tar.gz"
  sha256 "487eb406579689803ce0397f6102b18641e4572ac7bc9b9e5f3027c84dcf67ff"

  bottle do
    rebuild 1
    sha256 "9214db286259fd2c7d7127542b4a247a6059186fd22731409475114d4ddd0860" => :high_sierra
    sha256 "12b5cd82cfb991999c8c151f4d1b6e2c0da45979dc1b6275099aeb0325ddcdc8" => :sierra
    sha256 "cd1f3e4b99d653f9086b32a76addf6547d8e07aeac9c774d838cbb163de1001d" => :el_capitan
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
