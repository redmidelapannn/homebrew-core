class Libimobiledevice < Formula
  desc "Library to communicate with iOS devices natively"
  homepage "https://www.libimobiledevice.org/"
  url "https://www.libimobiledevice.org/downloads/libimobiledevice-1.2.0.tar.bz2"
  sha256 "786b0de0875053bf61b5531a86ae8119e320edab724fc62fe2150cc931f11037"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "3a1ba1befc46aa1e211bd867f88e10ae0f9867cfb63c5a2ebacc8058afa70a02" => :high_sierra
    sha256 "0ec00bbcdb12a2c795460abb95853eefe240530a22706ba93fa37c5319441cb7" => :sierra
    sha256 "891b0f7a65f551421648151211d1da80c39076c0f3ac06d0c58c8083d4e2838b" => :el_capitan
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
