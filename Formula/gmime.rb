class Gmime < Formula
  desc "MIME mail utilities"
  homepage "http://spruce.sourceforge.net/gmime/"
  url "https://download.gnome.org/sources/gmime/2.6/gmime-2.6.22.tar.xz"
  sha256 "c25f9097d5842a4808f1d62faf5eace24af2c51d6113da58d559a3bfe1d5553a"

  bottle do
    sha256 "343db5034316637b1d80ff48eaa2294d1316c05941ff3aa39e74058907609b02" => :sierra
    sha256 "65f8641cb86d0574e1f90e2635d7f63e05cc823ace09f7b8a13d803697b39631" => :el_capitan
    sha256 "c963f269a3047846147415a46c939e0aeea99968b6d9cc903f20142fc1a9d9da" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libgpg-error" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-largefile",
                          "--enable-introspection",
                          "--disable-vala",
                          "--disable-mono",
                          "--disable-glibtest"
    system "make", "install"
  end
end
