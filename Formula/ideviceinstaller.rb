class Ideviceinstaller < Formula
  desc "Cross-platform library and tools for communicating with iOS devices"
  homepage "http://www.libimobiledevice.org/"
  url "http://www.libimobiledevice.org/downloads/ideviceinstaller-1.1.0.tar.bz2"
  sha256 "0821b8d3ca6153d9bf82ceba2706f7bd0e3f07b90a138d79c2448e42362e2f53"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "c046e46885dc7f6ebab56c9faed6cc1f3c76d619e651a7297f54bfe9161f5202" => :el_capitan
    sha256 "61c4fc216657bb71d6079428bdcca14c61f1f28933ffe88887825dc041b5b2b8" => :yosemite
    sha256 "0593ea14bfd1213f0190dae91a09294eae15d88646af74549e293bb9d427770e" => :mavericks
  end

  head do
    url "http://git.sukimashita.com/ideviceinstaller.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libplist"
  depends_on "libimobiledevice"
  depends_on "libzip"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/ideviceinstaller --help |grep -q ^Usage"
  end
end
