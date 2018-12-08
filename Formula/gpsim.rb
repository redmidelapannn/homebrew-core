class Gpsim < Formula
  desc "Simulator for Microchip's PIC microcontrollers"
  homepage "https://gpsim.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gpsim/gpsim/0.30.0/gpsim-0.30.0.tar.gz"
  sha256 "e1927312c37119bc26d6abf2c250072a279a9c764c49ae9d71b4ccebb8154f86"
  head "https://svn.code.sf.net/p/gpsim/code/trunk"

  bottle do
    cellar :any
    rebuild 1
    sha256 "feae26ffc799b5827606ef1dc05714ee060c2e42f0222d8d6bb8e42e1fb79854" => :mojave
    sha256 "ed7ddc0cb9782268329ee888f30bfa05a9dcb4bda349249ed4804f934fc7f191" => :high_sierra
    sha256 "713dc86db4caf6a735a82cd0aa4abd6469220611c01bfcef990b7df6ddca59c8" => :sierra
  end

  depends_on "gputils" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "popt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-gui",
                          "--disable-shared",
                          "--prefix=#{prefix}"
    system "make", "all"
    system "make", "install"
  end

  test do
    system "#{bin}/gpsim", "--version"
  end
end
