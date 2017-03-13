class Sdcc < Formula
  desc "ANSI C compiler for Intel 8051, Maxim 80DS390, and Zilog Z80"
  homepage "https://sdcc.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sdcc/sdcc/3.6.0/sdcc-src-3.6.0.tar.bz2"
  sha256 "e85dceb11e01ffefb545ec389da91265130c91953589392dddd2e5ec0b7ca374"

  head "https://svn.code.sf.net/p/sdcc/code/trunk/sdcc"

  bottle do
    rebuild 1
    sha256 "bcee090f11faa0a010d43fd8c3743dabb21cde13e2d71aad24762de7039efafd" => :sierra
    sha256 "23066f363ff8f02ed7bc73108e15ed679287d105469717435d9ddd2944ee964a" => :el_capitan
    sha256 "1e4a1a397afe977350e2c1071d9236472e92a5e4ce9adf839e7b15a2039a2cf7" => :yosemite
  end

  option "with-avr-port", "Enables the AVR port (UNSUPPORTED, MAY FAIL)"
  option "with-xa51-port", "Enables the xa51 port (UNSUPPORTED, MAY FAIL)"

  deprecated_option "enable-avr-port" => "with-avr-port"
  deprecated_option "enable-xa51-port" => "with-xa51-port"

  depends_on "gputils"
  depends_on "boost"

  def install
    args = %W[--prefix=#{prefix}]
    args << "--enable-avr-port" if build.with? "avr-port"
    args << "--enable-xa51-port" if build.with? "xa51-port"

    system "./configure", *args
    system "make", "all"
    system "make", "install"
    rm Dir["#{bin}/*.el"]
  end

  test do
    system "#{bin}/sdcc", "-v"
  end
end
