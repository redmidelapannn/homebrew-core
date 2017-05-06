class Avrdude < Formula
  desc "Atmel AVR MCU programmer"
  homepage "https://savannah.nongnu.org/projects/avrdude/"
  url "https://download.savannah.gnu.org/releases/avrdude/avrdude-6.3.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/avrdude/avrdude-6.3.tar.gz"
  sha256 "0f9f731b6394ca7795b88359689a7fa1fba818c6e1d962513eb28da670e0a196"

  bottle do
    rebuild 1
    sha256 "3842dc0b0af9909ada8b9a20b21fbd78c4c5f47474468bfbec7a206fdf770345" => :sierra
    sha256 "ad9e3529f29c3df4dcb16766458f76b8ebb6f0a4df4fc063f142f84667055191" => :el_capitan
    sha256 "a0047f93822674470ff2cab0f5d141696af06eb7a0af54042e38494c32c7674a" => :yosemite
  end

  head do
    url "svn://svn.savannah.nongnu.org/avrdude/trunk/avrdude/"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libusb-compat"
  depends_on "libftdi0"
  depends_on "libelf"
  depends_on "libhid" => :optional

  def install
    if build.head?
      inreplace "bootstrap", /libtoolize/, "glibtoolize"
      system "./bootstrap"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "avrdude done.  Thank you.",
      shell_output("#{bin}/avrdude -c jtag2 -p x16a4 2>&1", 1).strip
  end
end
