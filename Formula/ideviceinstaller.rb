class Ideviceinstaller < Formula
  desc "Cross-platform library for communicating with iOS devices"
  homepage "http://www.libimobiledevice.org/"
  url "http://www.libimobiledevice.org/downloads/ideviceinstaller-1.1.0.tar.bz2"
  sha256 "0821b8d3ca6153d9bf82ceba2706f7bd0e3f07b90a138d79c2448e42362e2f53"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "919f567b2c1ff5654224750a6c9ff638b055b085a0e155fc07cab616bab7337c" => :sierra
    sha256 "a4004359fa50d7310c5021eabc0faf63451bb725beafa69f6baaef7ccd558c7d" => :el_capitan
    sha256 "ae827dab9c197c63228f5729af233a082c7d59170b5825242250284b13e8018e" => :yosemite
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
