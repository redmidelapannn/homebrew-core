class Jpeg < Formula
  desc "Image manipulation library"
  homepage "https://www.ijg.org/"
  url "https://www.ijg.org/files/jpegsrc.v9c.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/jpeg-9c.tar.gz"
  mirror "https://fossies.org/linux/misc/jpegsrc.v9c.tar.gz"
  sha256 "650250979303a649e21f87b5ccd02672af1ea6954b911342ea491f351ceb7122"
  revision 1

  bottle do
    cellar :any
    sha256 "5be4d7e0144b52a5eee70bec3b1ce2aaa422da54cd3e26503742e02e352bb244" => :mojave
    sha256 "450929ed1abc79b23f0ff0d763c19de27bba7d7c73f17a9ca00d22123039f209" => :high_sierra
    sha256 "b0ba9b6c20eedf34cc6ffdb6155d2da537113e97096a56fb339ed684c079fabe" => :sierra
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
