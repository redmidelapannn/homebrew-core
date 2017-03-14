class JpegAT9 < Formula
  desc "JPEG image manipulation library"
  homepage "http://www.ijg.org"
  url "http://www.ijg.org/files/jpegsrc.v9b.tar.gz"
  version "9.1"
  sha256 "240fd398da741669bf3c90366f58452ea59041cacc741a489b99f2f6a0bad052"

  bottle do
    cellar :any
    sha256 "68ce2c4ead8997946d77cd6181364101c0fe308b41bdfb920f6ea813ae1a7e40" => :sierra
    sha256 "b363bfee05e151566c73a6fdb4b07e8d1b4148cb9c4dd7ebdb9cb3ffe65743af" => :el_capitan
    sha256 "b97df7bc5410f82373de7800082739aa7710ce97474a18d1a680c00ecf6889e0" => :yosemite
  end

  keg_only :versioned_formula

  def install
    # Builds static and shared libraries.
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/djpeg", test_fixtures("test.jpg")
  end
end
