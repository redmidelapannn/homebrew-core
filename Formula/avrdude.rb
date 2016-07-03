class Avrdude < Formula
  desc "Atmel AVR MCU programmer"
  homepage "https://savannah.nongnu.org/projects/avrdude/"
  url "https://download.savannah.gnu.org/releases/avrdude/avrdude-6.3.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/avrdude/avrdude-6.3.tar.gz"
  sha256 "0f9f731b6394ca7795b88359689a7fa1fba818c6e1d962513eb28da670e0a196"

  bottle do
    revision 1
    sha256 "6481489dcd973dd2745c83849debc9f14d9172d0a73e68c9698630c54a0fd583" => :el_capitan
    sha256 "1d69218bf61b88479504fc318da759a41ddb531acdcdd77b1141d2b7c2527a2f" => :yosemite
    sha256 "3f04d577c0510a08644ee812da02a33c09a65851522ce09c40b85e7f27c09b6f" => :mavericks
  end

  head do
    url "svn://svn.savannah.nongnu.org/avrdude/trunk/avrdude/"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on :macos => :snow_leopard # needs GCD/libdispatch
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
