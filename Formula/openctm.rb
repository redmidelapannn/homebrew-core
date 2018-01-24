class Openctm < Formula
  desc "File format for storing 3D triangle meshes"
  homepage "https://openctm.sourceforge.io"
  url "https://download.sourceforge.net/project/openctm/OpenCTM-1.0.3/OpenCTM-1.0.3-src.tar.bz2"
  sha256 "4a8d2608d97364f7eec56b7c637c56b9308ae98286b3e90dbb7413c90e943f1d"

  bottle do
    cellar :any
    sha256 "1dd922f975a48413dc2a577c99dedb8027bf2f737c4395e3e0b66bbb876e03b2" => :high_sierra
    sha256 "b5741828382a83e19de79976535fa4c0bfb3c6e2a68a53f7d8d0580f77830592" => :sierra
    sha256 "962a7a9552d3f34b6fdf32603ecf600d5f5fea937af547fc878891b3db34ead5" => :el_capitan
  end

  depends_on "gtk+"

  def install
    system "make", "-f", "Makefile.macosx"

    mkdir lib
    mkdir include
    mkdir bin
    mkdir man1
    system "make", "LIBDIR=#{lib}/",
                   "INCDIR=#{include}/",
                   "BINDIR=#{bin}/",
                   "MAN1DIR=#{man1}/",
                   "-f", "Makefile.macosx", "install"
  end

  test do
    system "#{bin}/ctmconv"
  end
end
