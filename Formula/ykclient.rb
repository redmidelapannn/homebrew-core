class Ykclient < Formula
  desc "Library to validate YubiKey OTPs against YubiCloud"
  homepage "https://developers.yubico.com/yubico-c-client/"
  url "https://developers.yubico.com/yubico-c-client/Releases/ykclient-2.15.tar.gz"
  sha256 "f461cdefe7955d58bbd09d0eb7a15b36cb3576b88adbd68008f40ea978ea5016"

  bottle do
    rebuild 2
    sha256 "986ca78e328888452c78f8d922fde5db42058ef8fab261147c997e99ba3c8cc4" => :sierra
    sha256 "768cfeb6f0a542bc82611b7bcbce82fbbde7428d6ce0632abe429e3dff007346" => :el_capitan
    sha256 "207482c873fa931e69b8284cd105d6db6cdac8f477387973d4099ee3de40db2c" => :yosemite
  end

  head do
    url "https://github.com/Yubico/yubico-c-client.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "help2man" => :build

  def install
    system "autoreconf", "-iv" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    system "make", "check"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/ykclient --version").chomp
  end
end
