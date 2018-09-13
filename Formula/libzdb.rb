class Libzdb < Formula
  desc "Database connection pool library"
  homepage "https://tildeslash.com/libzdb/"
  url "https://tildeslash.com/libzdb/dist/libzdb-3.1.tar.gz"
  sha256 "0f01abb1b01d1a1f4ab9b55ad3ba445d203fc3b4757abdf53e1d85e2b7b42695"
  revision 6

  bottle do
    cellar :any
    rebuild 1
    sha256 "cc4124cba527ba07c83968f1fb60acf7081cf0a4bd5682d1284dad2f95370561" => :mojave
    sha256 "93f714240c2d645acaafe4f52c46fd0c38d37fde8e82c23c5aad1bfcceae8c39" => :high_sierra
    sha256 "c6ee6ff55b850ed4d5ba34545bdc8d86197d8af828c707f5f45930fec5ec889a" => :sierra
    sha256 "ddaefe96d7dd6751a7cf2737cd8fa2611b62a76f8abc3e52b7a8819376bd861e" => :el_capitan
  end

  depends_on "mysql-client"
  depends_on "openssl"
  depends_on "postgresql"
  depends_on "sqlite"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end
end
