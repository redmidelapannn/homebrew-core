class Ifuse < Formula
  desc "FUSE module for iPhone and iPod Touch devices"
  homepage "http://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/ifuse/archive/1.1.3.tar.gz"
  sha256 "9b63afa6f2182da9e8c04b9e5a25c509f16f96f5439a271413956ecb67143089"
  head "https://cgit.sukimashita.com/ifuse.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b687d4247d6b6c53c7e8ec3bfc1c8dd1e9326b0d09a516c4898c8088d6350058" => :sierra
    sha256 "bc7e3515cecd1a3a403fa585be888b99de441c30caf12e39c5bce5cc0b07a22d" => :el_capitan
    sha256 "38d6e53e489f560b81cb13f6d7093d4f640fbb4f783362ce0f838c5b798312b6" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "glib"
  depends_on "libimobiledevice"
  depends_on :osxfuse

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
