class Libimobiledevice < Formula
  desc "Library to communicate with iOS devices natively"
  homepage "http://www.libimobiledevice.org/"
  url "http://www.libimobiledevice.org/downloads/libimobiledevice-1.2.0.tar.bz2"
  sha256 "786b0de0875053bf61b5531a86ae8119e320edab724fc62fe2150cc931f11037"

  bottle do
    cellar :any
    revision 1
    sha256 "27b60d717d7ed5e26f92bcd66aa78aa8d24f6827417d60b4e31e47f28ade8e3a" => :el_capitan
    sha256 "9e03f51012e71c00766f056b41fc4c1ed709e348a1f43d3ca0f05062ec0aa854" => :yosemite
    sha256 "67d2cb36da543f14627e36bd386257b79ba17293282b9e0e4e9c8e6bde3e60b3" => :mavericks
  end

  head do
    url "https://git.libimobiledevice.org/libimobiledevice.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "libxml2"
  end

  depends_on "pkg-config" => :build
  depends_on "libtasn1"
  depends_on "libplist"
  depends_on "usbmuxd"
  depends_on "openssl"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          # As long as libplist builds without Cython
                          # bindings, libimobiledevice must as well.
                          "--without-cython"
    system "make", "install"
  end

  test do
    system "#{bin}/idevicedate", "--help"
  end
end
