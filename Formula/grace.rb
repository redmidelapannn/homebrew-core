class Grace < Formula
  desc "WYSIWYG 2D plotting tool for X11"
  homepage "https://plasma-gate.weizmann.ac.il/Grace/"
  url "https://deb.debian.org/debian/pool/main/g/grace/grace_5.1.25.orig.tar.gz"
  sha256 "751ab9917ed0f6232073c193aba74046037e185d73b77bab0f5af3e3ff1da2ac"
  revision 2

  bottle do
    rebuild 1
    sha256 "7b7b1407c07c448f29ccef846d13d36aa4af82de9a5065d6dc0143be77625b2c" => :catalina
    sha256 "b0d8484ef497a09c75d9d546f1bab94dd5a519e92bff76ef6258a4aba4432a05" => :mojave
    sha256 "0b336d088daa7b24a08d3b1d0336a981bb56ce3497093ab1f060d17b96cb38e4" => :high_sierra
  end

  depends_on "fftw"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "openmotif"
  depends_on "pdflib-lite"
  depends_on :x11

  def install
    ENV.O1 # https://github.com/Homebrew/homebrew/issues/27840#issuecomment-38536704
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-grace-home=#{prefix}"
    system "make", "install"
    share.install "fonts", "examples"
    man1.install Dir["doc/*.1"]
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"gracebat", share/"examples/test.dat"
    assert_equal "12/31/1999 23:59:59.999",
                 shell_output("#{bin}/convcal -i iso -o us 1999-12-31T23:59:59.999").chomp
  end
end
