class Libewf < Formula
  desc "Library for support of the Expert Witness Compression Format"
  homepage "https://github.com/libyal/libewf"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/libe/libewf/libewf_20140608.orig.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/libe/libewf/libewf_20140608.orig.tar.gz"
  version "20140608"
  sha256 "d14030ce6122727935fbd676d0876808da1e112721f3cb108564a4d9bf73da71"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "9025271f93f7721b42aed171fc090ac6bf242ea7da569eb2a6c3ce64237a288f" => :mojave
    sha256 "d2d28afee62a243edf583c28f8c280ab3da0a5bf419ef8e437820391c421ef55" => :high_sierra
    sha256 "5c044e6c6a2fc85cbd46a98ca5b357559b259ef1d0768c4b80fd4107be1129ea" => :sierra
  end

  head do
    url "https://github.com/libyal/libewf.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on :osxfuse => :optional

  def install
    if build.head?
      system "./synclibs.sh"
      system "./autogen.sh"
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    args << "--with-libfuse=no" if build.without? "osxfuse"

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ewfinfo -V")
  end
end
