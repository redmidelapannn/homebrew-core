class Libimobiledevice < Formula
  desc "Library to communicate with iOS devices natively"
  homepage "http://www.libimobiledevice.org/"
  url "http://www.libimobiledevice.org/downloads/libimobiledevice-1.2.0.tar.bz2"
  sha256 "786b0de0875053bf61b5531a86ae8119e320edab724fc62fe2150cc931f11037"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6ed84a275ef4c58c82954dd78e8361686bc6600314c17e1d89e36460928dd5f4" => :sierra
    sha256 "07219d1f5a6a55543f7be364341fda731672a3411977df4f2358b8e213191971" => :el_capitan
    sha256 "77a88cb2d85e54c2e39beed37430eb5a8b5e90d945b588dc9e421e3f79c18c37" => :yosemite
  end

  head do
    url "https://github.com/libimobiledevice/libimobiledevice.git"
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
