class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "https://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "https://www.pgpool.net/download.php?f=pgpool-II-3.6.2.tar.gz"
  sha256 "f90de6dbe3b2fd7adac7521fc285a1addf1585102c7f7eddb48147a0801d1158"

  bottle do
    rebuild 1
    sha256 "2bd0e2ef41528af0a2ae4436b497e3d4f7efb013e27e6a31826c611ea96b3cbc" => :sierra
    sha256 "e6871cbd9a5098a4ccc0b2c6722ef91e45834253327fec853d93b361cb304cf9" => :el_capitan
    sha256 "9481f958681655adab0c10654d5cd9cb16aa24284510006cee637fad26ee2b58" => :yosemite
  end

  depends_on :postgresql

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    cp etc/"pgpool.conf.sample", testpath/"pgpool.conf"
    system bin/"pg_md5", "--md5auth", "pool_passwd", "--config-file", "pgpool.conf"
  end
end
