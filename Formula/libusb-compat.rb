class LibusbCompat < Formula
  desc "Library for USB device access"
  homepage "http://www.libusb.org/"
  url "https://downloads.sourceforge.net/project/libusb/libusb-compat-0.1/libusb-compat-0.1.5/libusb-compat-0.1.5.tar.bz2"
  sha256 "404ef4b6b324be79ac1bfb3d839eac860fbc929e6acb1ef88793a6ea328bc55a"

  bottle do
    cellar :any
    rebuild 2
    sha256 "62d5e320f8d24dd262f1dcade533f173d803ac25ec0633263ef429ee345796c7" => :sierra
    sha256 "a1323bda0caaf4f699b317a84d249a1c83b6122ebe43c017216ed8ac64e6ab6a" => :el_capitan
    sha256 "059ea9c26d0ef29ec87f4e5117892ea541a2e32733dc951b8b2a31144372c39f" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/libusb-config", "--libs"
  end
end
