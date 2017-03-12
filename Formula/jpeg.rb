class Jpeg < Formula
  desc "Image manipulation library"
  homepage "http://www.ijg.org"
  url "http://www.ijg.org/files/jpegsrc.v8d.tar.gz"
  sha256 "00029b1473f0f0ea72fbca3230e8cb25797fbb27e58ae2e46bb8bf5a806fe0b3"

  bottle do
    cellar :any
    rebuild 3
    sha256 "8aa4210082bb6e80fd8fd53259ab112a34bd874e762ba2bd280a323c25f869c9" => :sierra
    sha256 "37dfdd273acd379c0c7692c99be3f8b25f9ee84684c8d2bfe32a724a5d3fada9" => :el_capitan
    sha256 "aefaf45e20696d8f719409622d15ea2104438aa5dcc64f9ba7fff363a0bfdfca" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/djpeg", test_fixtures("test.jpg")
  end
end
