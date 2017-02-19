class Blitz < Formula
  desc "C++ class library for scientific computing"
  homepage "https://blitz.sourceforge.io"
  url "https://downloads.sourceforge.net/project/blitz/blitz/Blitz++%200.10/blitz-0.10.tar.gz"
  sha256 "804ef0e6911d43642a2ea1894e47c6007e4c185c866a7d68bad1e4c8ac4e6f94"

  bottle do
    cellar :any
    rebuild 1
    sha256 "49ab5e47b21dbaca2a3b5968c909fdec193b337cb47a26c5f2f44d1c8b804f37" => :el_capitan
    sha256 "1e2c12a931e5383d1cd7e364572e2c7e1ba31067ed6b5ab1ff788e90a7827029" => :yosemite
  end

  head do
    url "http://blitz.hg.sourceforge.net:8000/hgroot/blitz/blitz", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-fi" if build.head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--infodir=#{info}",
                          "--enable-shared",
                          "--disable-doxygen",
                          "--disable-dot",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
