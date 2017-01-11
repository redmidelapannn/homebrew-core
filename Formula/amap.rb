class Amap < Formula
  desc "Perform application protocol detection"
  homepage "https://www.thc.org/thc-amap/"
  url "https://www.thc.org/releases/amap-5.4.tar.gz"
  sha256 "a75ea58de75034de6b10b0de0065ec88e32f9e9af11c7d69edbffc4da9a5b059"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "deb135721d22af85d901b344c21910ef92346fc8b266556219ed46fc7ba52ac6" => :sierra
    sha256 "ead758004b30477c1d27b96757a170c8050c1a43174288cbf9466e8a3cf1d4b6" => :el_capitan
    sha256 "67faa3bf6b5163b5e7933b76a2c163518b9a8f5a0dbf572f1f1d86ef98ca7674" => :yosemite
  end

  depends_on "openssl"

  def install
    # Last release was 2011 & there's nowhere supported to report this.
    openssl = Formula["openssl"]
    inreplace "configure" do |s|
      s.gsub! 'SSL_IPATH=""', "SSL_IPATH=\"#{openssl.opt_include}/openssl\""
      s.gsub! 'SSL_PATH=""', "SSL_PATH=\"#{openssl.opt_lib}\""
      s.gsub! 'CRYPTO_PATH=""', "CRYPTO_PATH=\"#{openssl.opt_lib}\""
    end

    system "./configure", "--prefix=#{prefix}"
    system "make"

    # --prefix doesn't work as we want it to so install manually
    bin.install "amap", "amap6", "amapcrap"
    etc.install "appdefs.resp", "appdefs.rpc", "appdefs.trig"
    man1.install "amap.1"
  end

  test do
    openssl_linked = MachO::Tools.dylibs("#{bin}/amap").any? { |d| d.include? Formula["openssl"].opt_lib.to_s }
    assert openssl_linked
    # We can do more than this, but unsure how polite it is to port-scan
    # someone's domain every time this goes through CI.
    assert_match version.to_s, shell_output("#{bin}/amap", 255)
  end
end
