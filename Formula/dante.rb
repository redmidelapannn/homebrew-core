class Dante < Formula
  desc "SOCKS server and client, implementing RFC 1928 and related standards"
  homepage "https://www.inet.no/dante/"
  url "https://www.inet.no/dante/files/dante-1.4.1.tar.gz"
  mirror "http://www.inet.no/dante/files/dante-1.4.1.tar.gz"
  sha256 "b6d232bd6fefc87d14bf97e447e4fcdeef4b28b16b048d804b50b48f261c4f53"

  bottle do
    cellar :any
    revision 2
    sha256 "8eadb7e4cae597431e69f5b3981e0a4d3995540d86c457283ea1929875af5ade" => :el_capitan
    sha256 "57e859617843e9dbefc2ed101dd8ff48b93d206bd2c7572ae63f91d9f711afb7" => :yosemite
    sha256 "ee3bac1a1eeb08b27754e3bac405dc726d31cb539f13d12b4a553f2363f26cc1" => :mavericks
  end

  depends_on "miniupnpc" => :optional

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/dante"
    system "make", "install"
  end

  test do
    system "#{sbin}/sockd", "-v"
  end
end
