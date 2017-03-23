class Theora < Formula
  desc "Open video compression format"
  homepage "https://www.theora.org/"
  url "http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2"
  sha256 "b6ae1ee2fa3d42ac489287d3ec34c5885730b1296f0801ae577a35193d3affbc"

  bottle do
    cellar :any
    rebuild 3
    sha256 "d71a70a75b6cdde98fa4f860461957f2388ee6be62e7ce66c2842b4671394f27" => :sierra
    sha256 "bdb26e1f20f73bfdf66ceb36c05e7a2573ba0b6283a6e8cf682119d9d9113c42" => :el_capitan
    sha256 "da9a7bce8cd8892e8293d1d48f131e47ff3a4a1d1614afe1d263e9759849255b" => :yosemite
  end

  devel do
    url "http://downloads.xiph.org/releases/theora/libtheora-1.2.0alpha1.tar.xz"
    version "1.2.0alpha1"
    sha256 "5be692c6be66c8ec06214c28628d7b6c9997464ae95c4937805e8057808d88f7"
  end

  head do
    url "https://git.xiph.org/theora.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "libogg"
  depends_on "libvorbis"

  def install
    cp Dir["#{Formula["libtool"].opt_share}/libtool/*/config.{guess,sub}"], buildpath
    system "./autogen.sh" if build.head?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-oggtest
      --disable-vorbistest
      --disable-examples
    ]

    args << "--disable-asm" unless build.stable?

    system "./configure", *args
    system "make", "install"
  end
end
