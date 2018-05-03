class LibusbCompat < Formula
  desc "Library for USB device access"
  homepage "https://libusb.info/"
  url "https://downloads.sourceforge.net/project/libusb/libusb-compat-0.1/libusb-compat-0.1.5/libusb-compat-0.1.5.tar.bz2"
  sha256 "404ef4b6b324be79ac1bfb3d839eac860fbc929e6acb1ef88793a6ea328bc55a"
  revision 1

  bottle do
    cellar :any
    rebuild 2
    sha256 "6e9981fedf7d3821a3d5d8cfa148a6754e8662e286a379de9e08379f4e9c907e" => :high_sierra
    sha256 "923937c076be4a692af26f8ea7c698b0db69328cafeeb609267f28a6e567847f" => :sierra
    sha256 "6a09fd55bb91ebf4be45fc5b3cf6cf99d3a1a74e9ff46c619b3cc02f614bab96" => :el_capitan
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
