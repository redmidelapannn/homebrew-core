class Uriparser < Formula
  desc "URI parsing library (strictly RFC 3986 compliant)"
  homepage "https://uriparser.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/uriparser/Sources/0.8.4/uriparser-0.8.4.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/u/uriparser/uriparser_0.8.4.orig.tar.bz2"
  sha256 "ce7ccda4136974889231e8426a785e7578e66a6283009cfd13f1b24a5e657b23"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e9192c610adf4ae1a109818222adec211369a235b2750a2a13db18ccb7c457d3" => :sierra
    sha256 "21bf0b78675cd55a05c997d141ea940a1304ff0093bb7b4f212b3756b7a708d2" => :el_capitan
    sha256 "9a6b24e4825ac31f1d05d44aff2a60e84947a7e4c5265bf444cd1fd5e04e2c3f" => :yosemite
  end

  head do
    url "https://git.code.sf.net/p/uriparser/git.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "cpptest"

  conflicts_with "libkml", :because => "both install `liburiparser.dylib`"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-doc"
    system "make", "check"
    system "make", "install"
  end

  test do
    expected = <<-EOS.undent
      uri:          https://brew.sh
      scheme:       https
      hostText:     brew.sh
      absolutePath: false
    EOS
    assert_equal expected, shell_output("#{bin}/uriparse https://brew.sh").chomp
  end
end
