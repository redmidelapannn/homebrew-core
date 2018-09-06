class OpenOcd < Formula
  desc "On-chip debugging, in-system programming and boundary-scan testing"
  homepage "https://sourceforge.net/projects/openocd/"
  url "https://downloads.sourceforge.net/project/openocd/openocd/0.10.0/openocd-0.10.0.tar.bz2"
  sha256 "7312e7d680752ac088b8b8f2b5ba3ff0d30e0a78139531847be4b75c101316ae"

  bottle do
    rebuild 2
    sha256 "a23891874387d4a20dc19ed69bf0521b98b53236523c2859acd7b58e4eb83fdc" => :mojave
    sha256 "c353af981515ebecafc5726e03ef19ad9b254c717b6bd3f6b36c374d28525ccd" => :high_sierra
    sha256 "30e914c99d624a71a4f8cbd6c5274189d3c06a9f67f965159f61e37e4ca670d3" => :sierra
    sha256 "eabbe9e78a745d215bc118f1c990659aa761d870507134a8dc7ac3feb8af0137" => :el_capitan
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
                          "--enable-dummy",
                          "--enable-jtag_vpi",
                          "--enable-remote-bitbang"
    system "make", "install"
  end
end
