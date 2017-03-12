class Libusb < Formula
  desc "Library for USB device access"
  homepage "http://libusb.info"
  url "https://github.com/libusb/libusb/releases/download/v1.0.21/libusb-1.0.21.tar.bz2"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/libu/libusb-1.0/libusb-1.0_1.0.21.orig.tar.bz2"
  sha256 "7dce9cce9a81194b7065ee912bcd55eeffebab694ea403ffb91b67db66b1824b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e3dd1dca59d394cefe263a70cc2d085743861a1dfe03dc1fb8289acf21e1f584" => :sierra
    sha256 "5699631f7ca3347d299d0688f15b591ee30d09f9c8b0d2a57b7afe7be6508cfd" => :el_capitan
    sha256 "1667419d0b5e6ab2147c41a22c8c1637e27dd2ea1f1e0d4944b9168e5f58bfc1" => :yosemite
  end

  head do
    url "https://github.com/libusb/libusb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "without-runtime-logging", "Build without runtime logging functionality"
  option "with-default-log-level-debug", "Build with default runtime log level of debug (instead of none)"

  deprecated_option "no-runtime-logging" => "without-runtime-logging"

  def install
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
