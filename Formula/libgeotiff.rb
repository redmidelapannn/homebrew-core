class Libgeotiff < Formula
  desc "Library and tools for dealing with GeoTIFF"
  homepage "https://geotiff.osgeo.org/"
  url "http://download.osgeo.org/geotiff/libgeotiff/libgeotiff-1.4.1.tar.gz"
  sha256 "acfc76ee19b3d41bb9c7e8b780ca55d413893a96c09f3b27bdb9b2573b41fd23"
  revision 1

  bottle do
    revision 1
    sha256 "050e32097032c10c0f0c220bb39db1e47ff985e823c463b31bee4c95ad8ad943" => :el_capitan
    sha256 "05f8092f1b5109af7f415ece8f403f17c33a2c6682b7a6fefb5326dde2227f26" => :yosemite
    sha256 "7b96522b1a1596622f103109d7ad0b5984d90589b0553b2373b34da561be77da" => :mavericks
  end

  depends_on "libtiff"
  depends_on "lzlib"
  depends_on "jpeg"
  depends_on "proj"

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}",
            "--with-libtiff=#{HOMEBREW_PREFIX}",
            "--with-zlib=#{HOMEBREW_PREFIX}",
            "--with-jpeg=#{HOMEBREW_PREFIX}"]
    system "./configure", *args
    system "make" # Separate steps or install fails
    system "make", "install"
  end
end
