class Blitz < Formula
  desc "C++ class library for scientific computing"
  homepage "https://blitz.sourceforge.io"
  url "https://downloads.sourceforge.net/project/blitz/blitz/Blitz++%200.10/blitz-0.10.tar.gz"
  sha256 "804ef0e6911d43642a2ea1894e47c6007e4c185c866a7d68bad1e4c8ac4e6f94"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3e32aafcc6e704e7097dfae4d69e07ad884306dae64b6f1ec2a42c3c97ee65a8" => :sierra
    sha256 "ee303e0dc0c4bd1046b27d328b0162bc417fac5f8611ae6fb8ec0ad169f6c297" => :el_capitan
    sha256 "f5ebd5655cf643165ff12ecf1990d7245263192885e8cf17cd6993fa1540d804" => :yosemite
  end

  head do
    url "https://github.com/blitzpp/blitz.git"

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
