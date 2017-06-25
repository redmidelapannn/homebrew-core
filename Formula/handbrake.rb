class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows."
  homepage "https://handbrake.fr/"
  url "https://handbrake.fr/mirror/HandBrake-1.0.7.tar.bz2"
  sha256 "ffdee112f0288f0146b965107956cd718408406b75db71c44d2188f5296e677f"
  head "https://github.com/HandBrake/HandBrake.git"

  bottle do
    rebuild 1
    sha256 "27abc59ca9e2e20ac2c8c278fbac556fb89ec21b9e69d6d5d51612c2c0aa9cd1" => :sierra
    sha256 "28f717e4efb37e699e3058f1ed26e9d0efc40e0f0b3a803385612471102df95e" => :el_capitan
    sha256 "d4020aa58a0d34b4cc4a45b6ffb202da7a11bac7bc3dde5b8a6f8d68e763684c" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "yasm" => :build

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-xcode",
                          "--disable-gtk"
    system "make", "-C", "build"
    system "make", "-C", "build", "install"
  end

  test do
    system bin/"HandBrakeCLI", "--help"
  end
end
