class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://download.handbrake.fr/releases/1.0.7/HandBrake-1.0.7.tar.bz2"
  sha256 "ffdee112f0288f0146b965107956cd718408406b75db71c44d2188f5296e677f"
  head "https://github.com/HandBrake/HandBrake.git"

  bottle do
    rebuild 1
    sha256 "7c14067c7248d1e5f01abd518a0ff66e23c049ef03fccd117085f3f5174e5e16" => :high_sierra
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
