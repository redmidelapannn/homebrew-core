class Libvorbis < Formula
  desc "Vorbis General Audio Compression Codec"
  homepage "http://vorbis.com/"
  url "http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.5.tar.xz"
  sha256 "54f94a9527ff0a88477be0a71c0bab09a4c3febe0ed878b24824906cd4b0e1d1"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ade609a31b5c8d345d43ac7f2ad78d8c143783fa53a86d3f4e18a2a12e111a3e" => :sierra
    sha256 "75da296e59f47e5f88b4f145b34fcfdfae240523f5c7f9a7a165608d33118848" => :el_capitan
    sha256 "9b46154e2ddd01709d3f8529d2de6a3e88770451b6fab8ae88b96d2a122801cf" => :yosemite
  end

  head do
    url "https://svn.xiph.org/trunk/vorbis"

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
