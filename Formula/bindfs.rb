class Bindfs < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.13.8.tar.gz"
  sha256 "7e7fcf070345d8cbb45186384e0aaf3e3a6375031d7a4f9533dd5d784c32c358"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ad2940df77adee30af32797e67cca46dfdf8598ab549ed1b42990b6edeb39f27" => :high_sierra
    sha256 "7545b30d2cf825bacab4ae19ed4efed618033a4c6bd3db212494c81ce6128cf9" => :sierra
    sha256 "a2bda8c200d05ccd21a99bbecf0d982cfb373105937613533ef592daed4c3ee6" => :el_capitan
  end

  head do
    url "https://github.com/mpartel/bindfs.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on :osxfuse

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  test do
    system "#{bin}/bindfs", "-V"
  end
end
