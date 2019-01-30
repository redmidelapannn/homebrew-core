class FuseEmulator < Formula
  desc "Free Unix Spectrum Emulator"
  homepage "https://fuse-emulator.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fuse-emulator/fuse/1.5.5/fuse-1.5.5.tar.gz"
  sha256 "bd0e58bd5a09444d79891da0971f9a84aa5670dd8018ac2b56f69e42ebda584e"

  bottle do
    rebuild 1
    sha256 "8695467e33da7fa88064f79119be39e90295b1a084e282e89f05f2068f612155" => :mojave
    sha256 "fd459ee9bb1a7458af6cabcb17fa2d273b17c762e9ba70f229aa916d352d508f" => :high_sierra
    sha256 "9622af6b59b7b16b35f917a4735022145141223d746e4f1ee2e4760887875f79" => :sierra
  end

  head do
    url "https://svn.code.sf.net/p/fuse-emulator/code/trunk/fuse"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "libspectrum"
  depends_on "sdl"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-sdltest",
                          "--with-sdl",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/fuse", "--version"
  end
end
