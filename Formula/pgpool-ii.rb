class PgpoolIi < Formula
  desc "PostgreSQL connection pool server"
  homepage "http://www.pgpool.net/mediawiki/index.php/Main_Page"
  url "http://www.pgpool.net/download.php?f=pgpool-II-3.4.3.tar.gz"
  sha256 "b030d1a0dfb919dabb90987f429b03a67b22ecdbeb0ec1bd969ebebe690006e4"
  revision 1

  bottle do
    cellar :any
    sha256 "b51979b07b15d4f09b229ece073bf7b8545ad7c1c2cccafe03cb0d65a0ed367f" => :sierra
    sha256 "04e66f144236b0cc58bbcf7aed3fa36b32d85233d052e5b5db6eeca2494ad831" => :el_capitan
    sha256 "4c0ca311b950bdb0d55e6e01fb13c9108642b0499569225ecad808eceb2dcc8c" => :yosemite
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
