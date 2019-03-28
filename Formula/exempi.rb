class Exempi < Formula
  desc "Library to parse XMP metadata"
  homepage "https://wiki.freedesktop.org/libopenraw/Exempi/"
  url "https://libopenraw.freedesktop.org/download/exempi-2.5.0.tar.bz2"
  sha256 "dc82fc24c0540a44a63fa4ad21775d24e00e63f1dedd3e2ae6f7aa27583b711b"

  bottle do
    cellar :any
    sha256 "45836b7114756f4a43b21423aa8469526a25300c455055ad76e837bb646aa30b" => :mojave
    sha256 "cb8963597a18110d41181ef79296a7f649330dbd21581f3bbc02209ad478d1bc" => :high_sierra
    sha256 "61b309245e23f723bdea631694de9809cc9ff9551abc87386eb063cef351c172" => :sierra
    sha256 "b1214df8ff8d55b48940e13e27cb7a0fcce0d423a8a791de876974622add734e" => :el_capitan
  end

  depends_on "boost"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end
end
