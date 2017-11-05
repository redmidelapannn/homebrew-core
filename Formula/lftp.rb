class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "https://lftp.yar.ru/"
  url "https://lftp.yar.ru/ftp/lftp-4.8.3.tar.xz"
  sha256 "de7aee451afaa1aa391f7076b5f602922c2da0e05524a8d8fea413eda83cc78b"

  bottle do
    rebuild 1
    sha256 "12936bfdcc7164b8bfe851541389aaaa3a331146bc2034b1b5869be2e1d23b5c" => :high_sierra
    sha256 "c8918fa375d62621155e7fb5a263671b8d94c823ab2413fc11ffe4cbe7199130" => :sierra
    sha256 "d0014af1c7b794fc050ec2a6f35f0605f7f18eae1b18e91c6fe3821b457fb88a" => :el_capitan
  end

  depends_on "readline"
  depends_on "openssl"
  depends_on "libidn"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--with-libidn=#{Formula["libidn"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/lftp", "-c", "open https://ftp.gnu.org/; ls"
  end
end
