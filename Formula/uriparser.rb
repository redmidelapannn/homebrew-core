class Uriparser < Formula
  desc "URI parsing library (strictly RFC 3986 compliant)"
  homepage "http://uriparser.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/uriparser/Sources/0.8.4/uriparser-0.8.4.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/u/uriparser/uriparser_0.8.4.orig.tar.bz2"
  sha256 "ce7ccda4136974889231e8426a785e7578e66a6283009cfd13f1b24a5e657b23"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0d2203d35ffeefec0c01ecc3d5144c24ec982ff013886504ccffacfe3a2dd3d2" => :el_capitan
    sha256 "2191a3370c67d7dc1cd488f911082392ca4f529bcfded6c4ec17fc963ec382a0" => :yosemite
    sha256 "c6626261ccf3cacbdba49f76c1fb38a9a4d7dfc821993591d27eae8ecaf016d4" => :mavericks
  end

  head do
    url "git://git.code.sf.net/p/uriparser/git"
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
      uri:          http://brew.sh
      scheme:       http
      hostText:     brew.sh
      absolutePath: false
    EOS
    assert_equal expected, shell_output("#{bin}/uriparse http://brew.sh").chomp
  end
end
