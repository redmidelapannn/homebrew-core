class FuseEmulator < Formula
  desc "Free Unix Spectrum Emulator"
  homepage "https://fuse-emulator.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fuse-emulator/fuse/1.5.5/fuse-1.5.5.tar.gz"
  sha256 "bd0e58bd5a09444d79891da0971f9a84aa5670dd8018ac2b56f69e42ebda584e"

  bottle do
    rebuild 1
    sha256 "e2c8cb6aadb5ac2655434eb88a4e1688539086fcc4bf2ac2a382a5e629fd87e1" => :mojave
    sha256 "503d5400e728ee7a49f71f6a64fefd14b64a5e3fbf30f8b538a73f2c7dbffebc" => :high_sierra
    sha256 "7e78bbdaf333ab48009d38cec499ea4a174167e4c66e68480a3b1cd322301d77" => :sierra
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
