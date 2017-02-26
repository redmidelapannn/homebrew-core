class Libvorbis < Formula
  desc "Vorbis General Audio Compression Codec"
  homepage "http://vorbis.com"
  url "http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.5.tar.xz"
  sha256 "54f94a9527ff0a88477be0a71c0bab09a4c3febe0ed878b24824906cd4b0e1d1"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3a94e7e51d48d254e4335925683c345c0b2abd16451ac918c408980e9b89ac19" => :sierra
    sha256 "efb38e3ba12c4dadacb5198d2a81a537b1aaf383f1e4f950c883ffae02fdb510" => :el_capitan
    sha256 "8547f5b6c7cdfcd10f59040d60fe1e792280106b017303f610a7f64fcc9157eb" => :yosemite
  end

  head do
    url "http://svn.xiph.org/trunk/vorbis"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
