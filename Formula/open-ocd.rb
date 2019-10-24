class OpenOcd < Formula
  desc "On-chip debugging, in-system programming and boundary-scan testing"
  homepage "http://openocd.org/"
  url "https://downloads.sourceforge.net/project/openocd/openocd/0.10.0/openocd-0.10.0.tar.bz2"
  sha256 "7312e7d680752ac088b8b8f2b5ba3ff0d30e0a78139531847be4b75c101316ae"

  bottle do
    rebuild 3
    sha256 "cfa6152c1586c3af39704955153d8c0a52b8470b3dcb2500997e49c13d69c83e" => :catalina
    sha256 "f1804ed1b490b779ad27bcd28706e72de6b53d79cb7d210eb8621d7d083bf32e" => :mojave
    sha256 "17ec4082f4423e99fbbbb0f54b9cd15f8cc83d80579220716db591a00819b6c9" => :high_sierra
  end

  head do
    url "https://git.code.sf.net/p/openocd/code.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "texinfo" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "hidapi"
  depends_on "libftdi"
  depends_on "libusb"
  depends_on "libusb-compat"

  def install
    ENV["CCACHE"] = "none"

    system "./bootstrap", "nosubmodule" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-buspirate",
                          "--enable-stlink",
                          "--enable-dummy",
                          "--enable-jtag_vpi",
                          "--enable-remote-bitbang"
    system "make", "install"
  end
end
