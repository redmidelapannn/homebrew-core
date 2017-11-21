class Mspdebug < Formula
  desc "Debugger for use with MSP430 MCUs"
  homepage "https://dlbeer.co.nz/mspdebug/"
  url "https://github.com/dlbeer/mspdebug/archive/v0.25.tar.gz"
  sha256 "347b5ae5d0ab0cddb54363b72abe482f9f5d6aedb8f230048de0ded28b7d1503"

  bottle do
    rebuild 1
    sha256 "78774f24893a6813cc5481f74cb536b433f2dfe3676b5689e9bd7a7b18fe3781" => :high_sierra
    sha256 "40903f0afd0df4477eaa639db0bd6b54aff674c209b327560e5868d61d2d8e3f" => :sierra
    sha256 "4e39a7d8ee1a0ecd30a313449f20c7177db6c4eb01089b4a3983f3405d608a88" => :el_capitan
  end

  depends_on "hidapi"
  depends_on "libusb-compat"

  def install
    ENV.append_to_cflags "-I#{Formula["hidapi"].opt_include}/hidapi"
    system "make", "PREFIX=#{prefix}", "install"
  end

  def caveats; <<~EOS
    You may need to install a kernel extension if you're having trouble with
    RF2500-like devices such as the TI Launchpad:
      https://dlbeer.co.nz/mspdebug/faq.html#rf2500_osx
    EOS
  end

  test do
    system bin/"mspdebug", "--help"
  end
end
