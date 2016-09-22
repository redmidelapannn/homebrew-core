class Hidapi < Formula
  desc "Library for communicating with USB and Bluetooth HID devices"
  homepage "https://github.com/signal11/hidapi"
  url "https://github.com/signal11/hidapi/archive/hidapi-0.8.0-rc1.tar.gz"
  sha256 "3c147200bf48a04c1e927cd81589c5ddceff61e6dac137a605f6ac9793f4af61"
  head "https://github.com/signal11/hidapi.git"

  # This patch addresses a bug discovered in the HidApi IOHidManager back-end
  # that is being used with Macs.
  # The bug was dramatically changing the behaviour of the function
  # "hid_get_feature_report". As a consequence, many applications working
  # with HidApi were not behaving correctly on OSX.
  # pull request on Hidapi's repo: https://github.com/signal11/hidapi/pull/219
  patch do
    url "https://github.com/signal11/hidapi/pull/219.patch"
    sha256 "d0a21a150425629a8388320df86818109e33d3230f6b0780c60524c9d15030ee"
  end

  bottle do
    cellar :any
    rebuild 3
    sha256 "1ba1ff0cd27c9468646111bc6ebe03e8e1233ae27baa2c148412effd08d30ff8" => :sierra
    sha256 "66e1ab2f45c8eefdbb663ce73f0cfe1d52f3c3a5680abf008c7ac6a08fc66266" => :el_capitan
    sha256 "b137f39790d00d163dc3f24540cfa3f66da1bafafab218af1a812010a8060144" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./bootstrap"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    bin.install "hidtest/.libs/hidtest"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include "hidapi.h"
      int main(void)
      {
        return hid_exit();
      }
    EOS

    flags = ["-I#{include}/hidapi", "-L#{lib}", "-lhidapi"] + ENV.cflags.to_s.split
    system ENV.cc, "-o", "test", "test.c", *flags
    system "./test"
  end
end
