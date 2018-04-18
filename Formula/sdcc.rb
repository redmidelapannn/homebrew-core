class Sdcc < Formula
  desc "ANSI C compiler for Intel 8051, Maxim 80DS390, and Zilog Z80"
  homepage "https://sdcc.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sdcc/sdcc/3.6.0/sdcc-src-3.6.0.tar.bz2"
  sha256 "e85dceb11e01ffefb545ec389da91265130c91953589392dddd2e5ec0b7ca374"

  head "https://svn.code.sf.net/p/sdcc/code/trunk/sdcc"

  bottle do
    rebuild 1
    sha256 "82540827a045ea45497bae47774761421f6d0f95642baa184bcfe78468111c1f" => :high_sierra
    sha256 "d1f568019ad7ff1ca9cfcc973538f914cf3deacca4b5794a1057835264a43e4d" => :sierra
    sha256 "71abff06efa7f35d577419837fdd1dda5819e97efa59f70595a789f91ce1c66f" => :el_capitan
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
