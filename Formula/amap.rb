class Amap < Formula
  desc "Perform application protocol detection"
  homepage "https://github.com/vanhauser-thc/THC-Archive"
  url "https://github.com/vanhauser-thc/THC-Archive/raw/master/Tools/amap-5.4.tar.gz"
  mirror "https://downloads.sourceforge.net/project/slackbuildsdirectlinks/amap/amap-5.4.tar.gz"
  sha256 "a75ea58de75034de6b10b0de0065ec88e32f9e9af11c7d69edbffc4da9a5b059"
  revision 3

  bottle do
    cellar :any
    rebuild 1
    sha256 "539f54e5c7b8cbb75de8f461d4c16adf645ad4d188b1bb6032f0a51f50032325" => :catalina
    sha256 "1482d69ac129c56917f85785b49eaf9fbfd5c3007fcdf1211c097de4cc227f8b" => :mojave
    sha256 "a3e89c82f3bc2acf246e6fca364d9423278608d51074325a4c7f188d1edfee39" => :high_sierra
  end

  depends_on "openssl@1.1"

  def install
    # Last release was 2011 & there's nowhere supported to report this.
    openssl = Formula["openssl@1.1"]
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
    openssl_linked = MachO::Tools.dylibs("#{bin}/amap").any? { |d| d.include? Formula["openssl@1.1"].opt_lib.to_s }
    assert openssl_linked
    # We can do more than this, but unsure how polite it is to port-scan
    # someone's domain every time this goes through CI.
    assert_match version.to_s, shell_output("#{bin}/amap", 255)
  end
end
