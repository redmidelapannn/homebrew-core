class Xplanet < Formula
  desc "Create HQ wallpapers of planet Earth"
  homepage "https://xplanet.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xplanet/xplanet/1.3.1/xplanet-1.3.1.tar.gz"
  sha256 "4380d570a8bf27b81fb629c97a636c1673407f4ac4989ce931720078a90aece7"
  revision 3

  bottle do
    sha256 "406839ba1a4d451f899b393ea22fc273351b6a4fdddee3b4541b1fde92f2e5c5" => :mojave
    sha256 "07271e18caa89a861e645c129f6bbf360ea1047c6dd740dbc5290ba34d23f43c" => :high_sierra
    sha256 "90194316b1365d6214cc81e7004276ca4bf4bcb0185411ed1722bcd26adc962b" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  # patches bug in 1.3.1 with flag -num_times=2 (1.3.2 will contain fix, when released)
  # https://sourceforge.net/p/xplanet/code/208/tree/trunk/src/libdisplay/DisplayOutput.cpp?diff=5056482efd48f8457fc7910a:207
  patch :p2 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/f952f1d/xplanet/xplanet-1.3.1-ntimes.patch"
    sha256 "3f95ba8d5886703afffdd61ac2a0cd147f8d659650e291979f26130d81b18433"
  end

  # Fix compilation with giflib 5
  # https://xplanet.sourceforge.io/FUDforum2/index.php?t=msg&th=592
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/master/xplanet/xplanet-1.3.1-giflib5.patch"
    sha256 "0a88a9c984462659da37db58d003da18a4c21c0f4cd8c5c52f5da2b118576d6e"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-aqua",
                          "--without-cspice",
                          "--without-cygwin",
                          "--without-gif",
                          "--without-jpeg",
                          "--without-libpng",
                          "--without-libtiff",
                          "--without-pango",
                          "--without-pnm",
                          "--without-x",
                          "--without-xscreensaver"

    system "make", "install"
  end

  test do
    system "#{bin}/xplanet", "-geometry", "4096x2160", "-projection", "mercator", "-gmtlabel", "-num_times", "1", "-output", "#{testpath}/xp-test.png"
  end
end
