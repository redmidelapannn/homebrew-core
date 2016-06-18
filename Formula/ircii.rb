class Ircii < Formula
  desc "IRC and ICB client"
  homepage "http://www.eterna.com.au/ircii/"
  url "https://ircii.warped.com/ircii-20151120.tar.bz2"
  sha256 "5dfd3fd364a96960e1f57ade4d755474556858653e4ce64265599520378c5f65"

  bottle do
    revision 1
    sha256 "4dadf9986ed6f3839018786f065889db7e7b8b9c5f4e43e0619e07df0acb5265" => :el_capitan
    sha256 "02a6b477947133025eed4239eb95f4b2ec68c19d566dec6b5dc667e6e76ba894" => :yosemite
    sha256 "1412ee5ed9f7b528f7d617a6e9824d0020472f15a7b801bdd1afa9c74ae12be5" => :mavericks
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
