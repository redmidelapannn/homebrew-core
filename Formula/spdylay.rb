class Spdylay < Formula
  desc "Experimental implementation of SPDY protocol versions 2, 3, and 3.1"
  homepage "https://github.com/tatsuhiro-t/spdylay"
  url "https://github.com/tatsuhiro-t/spdylay/archive/v1.3.2.tar.gz"
  sha256 "24f22378ffce6bd6e7e5ec69d44f3139ee102b1af59c39cddb5e6eadaf2484f8"

  bottle do
    cellar :any
    revision 1
    sha256 "8fad7492840009237a231dd6eedb6e38ab62e62872ccc8572c5a2faebd5bd58e" => :el_capitan
    sha256 "57a5803d2113cfec6133a06704edd716d016663265f43517778f491cf259bbe8" => :yosemite
    sha256 "13b4fb45bd58d4ac49d809120822b44acacc4bbf754c1ccd264d58af334edea8" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent" => :recommended
  depends_on "libxml2" if MacOS.version <= :lion
  depends_on "openssl"

  def install
    if MacOS.version > :lion
      Formula["libxml2"].stable.stage { (buildpath/"m4").install "libxml.m4" }
    end

    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/spdycat", "-ns", "https://www.google.com"
  end
end
