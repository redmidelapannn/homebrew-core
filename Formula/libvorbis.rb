class Libvorbis < Formula
  desc "Vorbis General Audio Compression Codec"
  homepage "http://vorbis.com/"
  url "http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.5.tar.xz"
  sha256 "54f94a9527ff0a88477be0a71c0bab09a4c3febe0ed878b24824906cd4b0e1d1"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "e4638909c00395a3d8ee574b7af55086fc9e012ae8f545eff5f55584080ee4d8" => :sierra
    sha256 "dae26047fd2b1c06d9e77df02753302d55d267e11eb8931cf41a9ef9943fbdf9" => :el_capitan
    sha256 "cd7a297edc14997d6f6f9094d7379228721732bbbde6d00c1699200af762ebd1" => :yosemite
  end

  head do
    url "https://git.xiph.org/vorbis.git"

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
