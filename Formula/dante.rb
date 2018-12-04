class Dante < Formula
  desc "SOCKS server and client, implementing RFC 1928 and related standards"
  homepage "https://www.inet.no/dante/"
  url "https://www.inet.no/dante/files/dante-1.4.2.tar.gz"
  sha256 "4c97cff23e5c9b00ca1ec8a95ab22972813921d7fbf60fc453e3e06382fc38a7"
  revision 1

  bottle do
    cellar :any
    sha256 "e3e9319cc18b3569fec4913f54e0280ef7e10caadd7ffaf2ac92413b7c1774c6" => :mojave
    sha256 "405603319eb06a88730303fb292f1ad00dc2c04b0ccd8939c5e2924c01b1ed6a" => :high_sierra
    sha256 "1d07768b1b84ec8e9419f1dc9d7143fbfd8b445ec510147c0c0c8de29ee74040" => :sierra
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-silent-rules",
                          # Enabling dependency tracking disables universal
                          # build, avoiding a build error on Mojave
                          "--enable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/dante"
    system "make", "install"
  end

  test do
    system "#{sbin}/sockd", "-v"
  end
end
