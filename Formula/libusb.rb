class Libusb < Formula
  desc "Library for USB device access"
  homepage "http://libusb.info"
  url "https://github.com/libusb/libusb/releases/download/v1.0.21/libusb-1.0.21.tar.bz2"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/libu/libusb-1.0/libusb-1.0_1.0.21.orig.tar.bz2"
  sha256 "7dce9cce9a81194b7065ee912bcd55eeffebab694ea403ffb91b67db66b1824b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5e9dfb54cd2b4a04d2079ad6e193484f61dc4e1e85e8c470116690443b50ff6a" => :sierra
    sha256 "a0cc0933454e7347698cfe30f12b36ce417b4e311efa4059e063364069dab1eb" => :el_capitan
    sha256 "9a12ec6763a77eecb995ba076ac50ed85e16869c80b70e52464f44c64cb6cdc5" => :yosemite
  end

  head do
    url "https://github.com/libusb/libusb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "universal", "Build universal binary (32-bit & 64-bit)"
  option "without-runtime-logging", "Build without runtime logging functionality"
  option "with-default-log-level-debug", "Build with default runtime log level of debug (instead of none)"

  deprecated_option "no-runtime-logging" => "without-runtime-logging"

  def install
    ENV.universal_binary if build.universal?

    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--disable-log" if build.without? "runtime-logging"
    args << "--enable-debug-log" if build.with? "default-log-level-debug"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
    pkgshare.install "examples"
  end

  test do
    cp_r (pkgshare/"examples"), testpath
    cd "examples" do
      system ENV.cc, "-lusb-1.0", "-L#{lib}", "-I#{include}/libusb-1.0",
             "listdevs.c", "-o", "test"
      system "./test"
    end
  end
end
