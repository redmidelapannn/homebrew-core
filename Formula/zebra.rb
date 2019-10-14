class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/zebra"
  url "http://ftp.indexdata.dk/pub/zebra/idzebra-2.1.4.tar.gz"
  sha256 "f45b0461cf40fafddd97d447695a087be0ba0981c108bf509d4c11f6d1db1ae2"
  revision 3

  bottle do
    sha256 "9c01a0d16725affc4e21b85e81c27152c51791c24e9e8011a229734d3247a112" => :catalina
    sha256 "c9fc110504bf2a865abbf36153f4b0733d6c0887a42f4a2b4f5f520e8ea2ad95" => :mojave
    sha256 "24b03aa52aabd804f3317c6955f79cd63eae37ea512e1a7b2bca78c643a7698b" => :high_sierra
  end

  depends_on "icu4c"
  depends_on "yaz"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-mod-text",
                          "--enable-mod-grs-regx",
                          "--enable-mod-grs-marc",
                          "--enable-mod-grs-xml",
                          "--enable-mod-dom",
                          "--enable-mod-alvis",
                          "--enable-mod-safari"
    system "make", "install"
  end

  test do
    cd share/"idzebra-2.0-examples/oai-pmh/" do
      system bin/"zebraidx-2.0", "-c", "conf/zebra.cfg", "init"
      system bin/"zebraidx-2.0", "-c", "conf/zebra.cfg", "commit"
    end
  end
end
