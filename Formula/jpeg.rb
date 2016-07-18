class Jpeg < Formula
  desc "JPEG image manipulation library"
  homepage "http://www.ijg.org"
  url "http://www.ijg.org/files/jpegsrc.v9b.tar.gz"
  sha256 "240fd398da741669bf3c90366f58452ea59041cacc741a489b99f2f6a0bad052"

  bottle do
    cellar :any
    sha256 "f9d8a885aa274b5747bc09e0a6ece065c653770440b007bc5b13fe759fc5f701" => :el_capitan
    sha256 "2849dd70fc22f734f39c761220b91844e028184eae11316a220985d50e03098d" => :yosemite
    sha256 "c220593a732a61be393992477edcbea1d38c4eb526c03614c1744f67a3355045" => :mavericks
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/djpeg", test_fixtures("test.jpg")
  end
end
