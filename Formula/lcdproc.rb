class Lcdproc < Formula
  desc "Display real-time system information on a LCD"
  homepage "http://www.lcdproc.org/"
  url "https://downloads.sourceforge.net/project/lcdproc/lcdproc/0.5.6/lcdproc-0.5.6.tar.gz"
  sha256 "bd2f43c30ff43b30f43110abe6b4a5bc8e0267cb9f57fa97cc5e5ef9488b984a"

  bottle do
    revision 1
    sha256 "4f2828b0291a6af86401d65a6747569e795709766a1a4ae0059db4ace5ccbe7f" => :el_capitan
    sha256 "57244c0b199b4f0ad04e5f22ffc392473be321c0a62d76c044a968030f29acf1" => :yosemite
    sha256 "311535acf22c4f02e4a3c57b5ba6baabd7483108a8521f563e40ad913b3b9485" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "libhid"
  depends_on "libftdi0"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-drivers=all",
                          "--enable-libftdi=yes"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lcdproc -v 2>&1")
  end
end
