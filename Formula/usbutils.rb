class Usbutils < Formula
  desc "Provides 'lsusb' tool for getting detailed info about USB devices"
  # Homepage for multiple Linux USB tools, 'usbutils' is one of them.
  homepage "https://linux-usb.sourceforge.io"
  # The latest version we can use is 007 (from 2013), because the later
  # versions depend on 'libudev': part of Systemd and not in Homebrew.
  url "https://mirrors.edge.kernel.org/pub/linux/utils/usb/usbutils/usbutils-007.tar.xz"
  sha256 "7593a01724bbc0fd9fe48e62bc721ceb61c76654f1d7b231b3c65f6dfbbaefa4"

  bottle do
    sha256 "40537f34ebd43f9590ab1e0ddc0f9f6c2252583460c293c2b821c850260b16dd" => :high_sierra
    sha256 "5976c4d75ca2f7a97013126f85e76d45d5bc0e3d5a7e61e535de5c2e69ea60f7" => :sierra
    sha256 "6f4024047e3161b2192c9e2dc84847ef688e8ddbb4d74066f9f60b3a60a1ad86" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    # Clear AM_LDFLAGS to remove unsupported "-Wl,--as-needed"
    # Also, clear/override several other variables, to avoid
    # building/installing linux-specific utilities that rely on sysfs.
    system "make", "install", "AM_LDFLAGS=", "SUBDIRS=", "bin_SCRIPTS=",
                              "man_MANS=lsusb.8"
  end

  test do
    # Run --version only. The normal 'lsusb' run may exit
    # with 1 if executed on a Virtual Machine.
    system "#{bin}/lsusb", "--version"
    # Make sure nothing shows up on stderr - 'lsusb' would print
    # a message if it could not find the USB ids file:
    _, stderr, status = Open3.capture3("#{bin}/lsusb")
    assert_true status.exited?
    assert_equal "", stderr
  end
end
