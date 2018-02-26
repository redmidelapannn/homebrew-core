class Libart < Formula
  desc "Library for high-performance 2D graphics"
  homepage "https://people.gnome.org/~mathieu/libart/libart.html"
  url "https://download.gnome.org/sources/libart_lgpl/2.3/libart_lgpl-2.3.21.tar.bz2"
  sha256 "fdc11e74c10fc9ffe4188537e2b370c0abacca7d89021d4d303afdf7fd7476fa"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6960b09c88458f1f92db53993258199fc642761a7646e2dd1b5fc4c70c574bcc" => :high_sierra
    sha256 "d7fa625ea8812a601acbafb82f7fb61ca5f7780c9908fc1509bf63cb18f1cc95" => :sierra
    sha256 "cbc53f2b77b2a22af772f248c61233e1a4f08970457b7acb86e57476db79a52a" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
