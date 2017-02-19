class Autotrace < Formula
  desc "Convert bitmap to vector graphics"
  homepage "https://autotrace.sourceforge.io"
  url "https://downloads.sourceforge.net/project/autotrace/AutoTrace/0.31.1/autotrace-0.31.1.tar.gz"
  sha256 "5a1a923c3335dfd7cbcccb2bbd4cc3d68cafe7713686a2f46a1591ed8a92aff6"
  revision 3

  bottle do
    cellar :any
    rebuild 1
    sha256 "e09467dcfee19b09f92a43c48f7b36ee9712fcd792b782b15fbf33a98a57cd7a" => :sierra
    sha256 "49865ab60e66d8449f50be77f2ee69296830edc3363641698730478f8453f723" => :el_capitan
    sha256 "b2a24d0506ec52b0715ace581beabcfcb12af38fee00a618bb5b0836337573fb" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "imagemagick" => :recommended

  # Issue 16569: Use MacPorts patch to port input-png.c to libpng 1.5.
  # Fix underquoted m4
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/5b41470/autotrace/patch-libpng-1.5.diff"
    sha256 "9c57a03d907db94956324e9199c7b5431701c51919af6dfcff4793421a1f31fe"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/5b41470/autotrace/patch-autotrace.m4.diff"
    sha256 "12d794c99938994f5798779ab268a88aff56af8ab4d509e14383a245ae713720"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    args << "--without-magick" if build.without? "imagemagick"

    system "./configure", *args
    system "make", "install"
  end
end
