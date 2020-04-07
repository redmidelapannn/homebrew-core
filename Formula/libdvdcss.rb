class Libdvdcss < Formula
  desc "Access DVDs as block devices without the decryption"
  homepage "https://www.videolan.org/developers/libdvdcss.html"
  url "https://download.videolan.org/pub/videolan/libdvdcss/1.4.2/libdvdcss-1.4.2.tar.bz2"
  sha256 "78c2ed77ec9c0d8fbed7bf7d3abc82068b8864be494cfad165821377ff3f2575"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ea741f5452116ba10c6e2667c091a8f7fe7fb0ed9c17ed703e1ce968f4bbe427" => :catalina
    sha256 "26abd7508ae5b4f49bbffeba67ea2dcd68fd1bb5404a2bc40cc2cd274c184c4b" => :mojave
    sha256 "ca89a41e79312d87d730ed549b94d540ea1d04abbf1027197a6214c4e586b78d" => :high_sierra
  end

  head do
    url "https://code.videolan.org/videolan/libdvdcss.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-if" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end
end
