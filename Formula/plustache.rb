class Plustache < Formula
  desc "C++ port of Mustache templating system"
  homepage "https://github.com/mrtazz/plustache"
  url "https://github.com/mrtazz/plustache/archive/v0.3.0.tar.gz"
  sha256 "ceb56d6cab81b8ed2d812e4a546036a46dd28685512255e3f52553ba70a15fc8"
  revision 1

  bottle do
    cellar :any
    sha256 "48ffbd231777c2ff026935d1f304256857669ef7c1a1512e0121d0ecc8b6e31f" => :sierra
    sha256 "341e0488971c04b23b56c35c7a81e653a1da01be7b095069f01c0f152f97b879" => :el_capitan
    sha256 "eba6810c73472cd056d9f41bce7c23829e42dbc6046dc5553f3615b38fb0b120" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "boost@1.61"

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
