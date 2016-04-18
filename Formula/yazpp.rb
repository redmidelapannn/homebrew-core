class Yazpp < Formula
  desc "C++ API for the Yaz toolkit"
  homepage "https://www.indexdata.com/yazpp"
  url "http://ftp.indexdata.dk/pub/yazpp/yazpp-1.6.2.tar.gz"
  sha256 "66943e4260664f9832ac654288459d447d241f1c26cab24902944e8b15c49878"

  bottle do
    cellar :any
    revision 1
    sha256 "f72d7674f0328e5a9032e7bb54c1084e4ba0764f348cec33d9659316c129f80f" => :el_capitan
    sha256 "5943fd4f148072b5de49a5a4f91b3de7e28618b94e817f2b05b7d4d28e58a4ad" => :yosemite
    sha256 "4d34abc7508c3dc914f62e33c2c249f7dab07713c48a2b292a269fc30cf80d11" => :mavericks
  end

  depends_on "yaz"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
