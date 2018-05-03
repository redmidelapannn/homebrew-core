class Libusb < Formula
  desc "Library for USB device access"
  homepage "https://libusb.info/"
  url "https://github.com/libusb/libusb/releases/download/v1.0.22/libusb-1.0.22.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/libusb/libusb-1.0/libusb-1.0.22/libusb-1.0.22.tar.bz2"
  sha256 "75aeb9d59a4fdb800d329a545c2e6799f732362193b465ea198f2aa275518157"

  bottle do
    cellar :any
    rebuild 1
    sha256 "cd5e16e18aa192a4e510bcc59a1cca3cb4e2fb5324fb38afda96001cc471bb79" => :high_sierra
    sha256 "c618853a2aad8a47acba929185416096ee8b65f637a708f2d2ccfb8ffed4ef2e" => :sierra
    sha256 "84f62660343172e948a019c59ca00a70d4523d5651ce2c5af77753531eb9c5c6" => :el_capitan
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
