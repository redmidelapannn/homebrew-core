class DfuUtil < Formula
  desc "USB programmer"
  homepage "https://dfu-util.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/dfu-util/dfu-util-0.9.tar.gz"
  sha256 "36428c6a6cb3088cad5a3592933385253da5f29f2effa61518ee5991ea38f833"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6d40303f75f0020c1ecf0699b9ec4acae36d964d8b8e466fe0f7a10973b640c8" => :sierra
    sha256 "5b1392dab6947bc5f8d6ef03cfb4f6759c60952eb4adc1933b48ed56feae2951" => :el_capitan
    sha256 "06eb17ff33cddfd512a91a11c74695d324bd858bd90b05721a82d011d8d86953" => :yosemite
  end

  head do
    url "https://git.code.sf.net/p/dfu-util/dfu-util.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"dfu-util", "-V"
    system bin/"dfu-prefix", "-V"
    system bin/"dfu-suffix", "-V"
  end
end
