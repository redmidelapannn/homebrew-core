class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.1.12.tar.gz"
  sha256 "5df43e0cd282a87891b378fc1650d839292326cf9655b20029668647f2239231"

  bottle do
    sha256 "d07d210cd393c5214dbf6037975e08aa676ae9b9a262a15b495fa6c8b0aca0b0" => :mojave
    sha256 "048aea71eb07da59298d6c0bfc47946bbf4aa4dbe5f0b94db7f62e49b7375ae7" => :high_sierra
    sha256 "75f2f5078908e3043e10ac99b0eac230c18d26931a3dc7c86ec348c3df8c9de0" => :sierra
  end

  head do
    url "https://github.com/FreeTDS/freetds.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "unixodbc"
  uses_from_macos "readline"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-tdsver=7.3
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-unixodbc=#{Formula["unixodbc"].opt_prefix}
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --enable-sybase-compat
      --enable-krb5
      --enable-odbc-wide
    ]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make"
    ENV.deparallelize # Or fails to install on multi-core machines
    system "make", "install"
  end

  test do
    system "#{bin}/tsql", "-C"
  end
end
