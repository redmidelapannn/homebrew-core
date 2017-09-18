class Epic5 < Formula
  desc "Enhanced, programmable IRC client"
  homepage "http://www.epicsol.org/"
  url "http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/epic5-2.0.1.tar.xz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/epic5/epic5-2.0.1.tar.xz"
  sha256 "55260fc832c76f7a4975bde2bd0d0805fd8012fc8908ac94ec8c6de24a1be7aa"
  head "http://git.epicsol.org/epic5.git"

  bottle do
    rebuild 1
    sha256 "a072be740e6890fca0e59b3cb984122df23490b92a4017505b7c215a15e37cd2" => :sierra
    sha256 "b6aeb624040ae9cd781e5a11d70237cd23f433fe1fdf153908ed72ef16df3159" => :el_capitan
  end

  depends_on "openssl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-ipv6",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}"
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    connection = fork do
      exec bin/"epic5", "irc.freenode.net"
    end
    sleep 5
    Process.kill("TERM", connection)
  end
end
