class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/zebra"
  url "http://ftp.indexdata.dk/pub/zebra/idzebra-2.1.0.tar.gz"
  sha256 "1544f7929d03153ba79ea171b2128f8cab463ae28407035ae5046f8c4a100ea6"
  revision 1

  bottle do
    sha256 "7c6c1efd86406e66ae91e1c3e9272f81046303e0dff41548e1e784ec81e904f5" => :sierra
    sha256 "ed5dd636c3854ec2e2108130d4148bb7348e5be1db61bc63ae71bcb32afba8a0" => :el_capitan
    sha256 "e4c831abdd3e0a3124a9454028b8e4ffab2810d306d75fe9f42d4f780273a99a" => :yosemite
  end

  depends_on "icu4c" => :recommended
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
