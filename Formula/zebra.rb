class Zebra < Formula
  desc "Information management system"
  homepage "https://www.indexdata.com/zebra"
  url "http://ftp.indexdata.dk/pub/zebra/idzebra-2.0.61.tar.gz"
  sha256 "e3e5d3c50500847c4d065c93108ab9fd0222a8dbddc12565090cfdd8a885cf6f"
  revision 1

  bottle do
    revision 1
    sha256 "c264a20f4723dc4b4de94edda0bc9c759b1d9a28e6a5a775ae090548b3db7f61" => :el_capitan
    sha256 "bcd895bf6d85932de78cfb6a167c201bffc2159ad66cf3d48dbd16f7b5efed31" => :yosemite
    sha256 "d9d0bb3711fc343eccaa095ccad8053d7d0b1bf2bc20d739f1bb5c40f4ee6d06" => :mavericks
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
      system "zebraidx-2.0", "-c", "conf/zebra.cfg", "init"
      system "zebraidx-2.0", "-c", "conf/zebra.cfg", "commit"
    end
  end
end
