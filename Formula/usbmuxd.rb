class Usbmuxd < Formula
  desc "USB multiplexor daemon for iPhone and iPod Touch devices"
  homepage "http://www.libimobiledevice.org/"
  revision 1

  stable do
    url "http://www.libimobiledevice.org/downloads/libusbmuxd-1.0.10.tar.bz2"
    sha256 "1aa21391265d2284ac3ccb7cf278126d10d354878589905b35e8102104fec9f2"

    # Backport of upstream security fix for CVE-2016-5104.
    patch do
      url "https://github.com/libimobiledevice/libusbmuxd/commit/4397b3376dc4.patch"
      sha256 "9f3a84c8d0a32df13985f6574f5f0e86af435a67606612c0811df631070a97e3"
    end
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "89acc0511d02d2d8d093896af4f0a8a371775d8d207c383cb6e35f363413fe3f" => :sierra
    sha256 "537e80e10bd792e9cb2c45c774c88ec5661d7872f4895238e0f154f6f107ccf5" => :el_capitan
    sha256 "f8054ff383f90fd55cf79ff19a86e56e98ac83155bae0311004e9aa0745e424e" => :yosemite
  end

  head do
    url "https://git.sukimashita.com/libusbmuxd.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "libplist"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"iproxy"
  end
end
