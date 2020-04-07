class Libdvdnav < Formula
  desc "DVD navigation library"
  homepage "https://www.videolan.org/developers/libdvdnav.html"
  url "https://download.videolan.org/pub/videolan/libdvdnav/6.1.0/libdvdnav-6.1.0.tar.bz2"
  sha256 "f697b15ea9f75e9f36bdf6ec3726308169f154e2b1e99865d0bbe823720cee5b"
  revision 1

  bottle do
    cellar :any
    sha256 "88f1c744e90e237ae1c1c7cefd7229e3a840ea6c331b67e162dc2642a4e7d0ac" => :catalina
    sha256 "4af02d9a1081a9eae2c0ee7c81ba2dfac36f2e869a5a985fb2823345f5b69e2d" => :mojave
    sha256 "9bb604be6bad30e69774e2432e31e8d61eb38e23b191392ecf6eed94e671f332" => :high_sierra
  end

  head do
    url "https://code.videolan.org/videolan/libdvdnav.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libdvdread"

  def install
    system "autoreconf", "-if" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
