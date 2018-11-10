class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/zebra"
  url "http://ftp.indexdata.dk/pub/zebra/idzebra-2.1.4.tar.gz"
  sha256 "f45b0461cf40fafddd97d447695a087be0ba0981c108bf509d4c11f6d1db1ae2"
  revision 1

  bottle do
    sha256 "6c48f95a10557d0b3e631354a393a35f57a65dfc4e49909508042fb7aad5235a" => :mojave
    sha256 "732a0fed2067ac7212b2e12f50fc5849c213f5384ff0558a585f0a1e46b0d618" => :high_sierra
    sha256 "7ceb9c07227ad3d1862e3a5b54a486d6cd790de94e57e0276f06e674203e56ef" => :sierra
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
