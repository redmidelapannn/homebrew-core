class Libdvdnav < Formula
  desc "DVD navigation library"
  homepage "https://www.videolan.org/developers/libdvdnav.html"
  url "https://download.videolan.org/pub/videolan/libdvdnav/6.1.0/libdvdnav-6.1.0.tar.bz2"
  sha256 "f697b15ea9f75e9f36bdf6ec3726308169f154e2b1e99865d0bbe823720cee5b"

  bottle do
    cellar :any
    sha256 "6149af7996394554471863543323734f13f344b3c3315fba1f55f3d108968b5d" => :catalina
    sha256 "6adf74f5f965353a8c0eeae751f47cebf05570e40d89ff0d6261afa37b8eb702" => :mojave
    sha256 "2d0c63d2887cca770ada3d02151dc3fab98276a3df7ee02359075de62183d36d" => :high_sierra
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
