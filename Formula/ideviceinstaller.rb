class Ideviceinstaller < Formula
  desc "Cross-platform library for communicating with iOS devices"
  homepage "https://www.libimobiledevice.org/"
  url "https://www.libimobiledevice.org/downloads/ideviceinstaller-1.1.0.tar.bz2"
  sha256 "0821b8d3ca6153d9bf82ceba2706f7bd0e3f07b90a138d79c2448e42362e2f53"
  revision 4

  bottle do
    cellar :any
    rebuild 1
    sha256 "aa7daae6009ae0b4d78990f9bf31496405fe89c0f245a77e8a46a11bc3c047a7" => :high_sierra
    sha256 "04e4700a9d7112d207169ebd67930c25b679d57c993eb5e75f379a05569eb032" => :sierra
    sha256 "28175b8befa3f7fba7d4e9df6f9869a8ee17b287ae46c9a326119c3d7de18208" => :el_capitan
  end

  head do
    url "https://git.sukimashita.com/ideviceinstaller.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
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
