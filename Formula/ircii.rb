class Ircii < Formula
  desc "IRC and ICB client"
  homepage "http://www.eterna.com.au/ircii/"
  url "http://ircii.warped.com/ircii-20151120.tar.bz2"
  sha256 "5dfd3fd364a96960e1f57ade4d755474556858653e4ce64265599520378c5f65"

  bottle do
    rebuild 1
    sha256 "20ed831b8db59b5a69b467bf9620fb6eda707a359d063ec4fbeff4c6fbe50405" => :sierra
    sha256 "629d851aae006223c492f93d8bfba9e803a195ac955f96ec7264131a56b370c7" => :el_capitan
    sha256 "4b1d4024f3478c507b5c01fb9436c90cfa8e35742bc079679973376b8e9ec041" => :yosemite
  end

  depends_on "openssl"

  def install
    ENV.append "LIBS", "-liconv"
    system "./configure", "--prefix=#{prefix}",
                          "--with-default-server=irc.freenode.net",
                          "--enable-ipv6"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end
end
