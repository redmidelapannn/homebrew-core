class Libkate < Formula
  desc "Overlay codec for multiplexed audio/video in Ogg"
  homepage "https://code.google.com/archive/p/libkate/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libkate/libkate-0.4.1.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/libk/libkate/libkate_0.4.1.orig.tar.gz"
  sha256 "c40e81d5866c3d4bf744e76ce0068d8f388f0e25f7e258ce0c8e76d7adc87b68"
  revision 1

  bottle do
    cellar :any
    rebuild 4
    sha256 "8233404a7329df2b5604c5c3fe59ccad2c2a8d3a85a0bc1f31ea653cf3090ee4" => :catalina
    sha256 "07fc2522c910cf369f5fbac30ffa87c8dc4af5019aa33adc3d04523eb9eb5598" => :mojave
    sha256 "9b27f53a5ee80a77f862c9efe0d51d92c2c5ca4acd5048fde3752ed46009db1e" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "libpng"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-shared",
                          "--enable-static",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin/"katedec", "-V"
  end
end
