class Jpeg < Formula
  desc "Image manipulation library"
  homepage "https://www.ijg.org/"
  url "https://www.ijg.org/files/jpegsrc.v9c.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/jpeg-9c.tar.gz"
  mirror "https://fossies.org/linux/misc/jpegsrc.v9c.tar.gz"
  sha256 "650250979303a649e21f87b5ccd02672af1ea6954b911342ea491f351ceb7122"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f472410f7a8f5b666727857474bdd88bcb4b01e0afd15c7d7c672ce93a68a946" => :high_sierra
    sha256 "8dc1b3e0f0eed3dc84c523ce171f2bca2c2acef64411c36da291fc2fdd0210f1" => :sierra
    sha256 "7124f57bd2fa8fb66ad148e66cf5708259c23aab258298e04f8cf8dcbb0147c3" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/djpeg", test_fixtures("test.jpg")
  end
end
