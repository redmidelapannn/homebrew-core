class Libsndfile < Formula
  desc "C library for files containing sampled sound"
  homepage "http://www.mega-nerd.com/libsndfile/"
  url "http://www.mega-nerd.com/libsndfile/files/libsndfile-1.0.27.tar.gz"
  sha256 "a391952f27f4a92ceb2b4c06493ac107896ed6c76be9a613a4731f076d30fac0"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4fc32330b92b3f5852b386bdbf97991033f774f83a56a34c88f78444be48dfdb" => :sierra
    sha256 "ddbe8b4f1addcadc53f5a8b635422daaadf6abedee5cea96662517bed3d51c60" => :el_capitan
    sha256 "5d6b7cabd6ce3b45eaa8ca304dc170c139c4984871744c71f596fad51288b983" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "flac"
  depends_on "libogg"
  depends_on "libvorbis"

  def install
    system "autoreconf", "-i"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
