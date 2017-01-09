class IosWebkitDebugProxy < Formula
  desc "DevTools proxy for iOS devices"
  homepage "https://github.com/google/ios-webkit-debug-proxy"
  url "https://github.com/google/ios-webkit-debug-proxy/archive/1.7.tar.gz"
  sha256 "e4f86d926a93b25672d4337af9c3549896125c7f345bb1d98eb3dca7da12c123"

  head "https://github.com/google/ios-webkit-debug-proxy.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "57f90d7f8e7cfcaa8c047f4dc24cc2b07007844bbb85858226dcf8dc1030c7d0" => :sierra
    sha256 "14cbd65a5da47b98bdf85da0cda87b2f49909c79e77257a0c66e988f8a9dd9d6" => :el_capitan
    sha256 "6a0b554c948e230b5cfe8fd814d0f400c1c7cf83998fdce1a7f9972ca608d74c" => :yosemite
  end

  depends_on :macos => :lion
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libplist"
  depends_on "usbmuxd"
  depends_on "libimobiledevice"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/ios_webkit_debug_proxy", "--help"
  end
end
