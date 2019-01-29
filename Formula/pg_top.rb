class PgTop < Formula
  desc "Monitor PostgreSQL processes"
  homepage "https://git.postgresql.org/gitweb/?p=pg_top.git"
  url "https://ftp.postgresql.org/pub/projects/pgFoundry/ptop/pg_top/3.7.0/pg_top-3.7.0.tar.bz2"
  mirror "https://mirrorservice.org/sites/ftp.postgresql.org/projects/pgFoundry/ptop/pg_top/3.7.0/pg_top-3.7.0.tar.bz2"
  sha256 "c48d726e8cd778712e712373a428086d95e2b29932e545ff2a948d043de5a6a2"
  revision 3

  bottle do
    cellar :any
    rebuild 1
    sha256 "1143e92a6ef3c6277f1d91d34271bd26ebc96524ab8d891173a92b86fa972648" => :mojave
    sha256 "110d7a4cdf244fc63dc49b5d4f1a0569ecc6ef8353d7ffec8709b784a437126d" => :high_sierra
    sha256 "53e4bb02195c2365290faa1d10f72bab272abebd3eae7b3a919cd7c177f38e79" => :sierra
  end

  depends_on "postgresql"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    (buildpath/"config.h").append_lines "#define HAVE_DECL_STRLCPY 1"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pg_top -V")
  end
end
