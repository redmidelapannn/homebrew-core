class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.1.16.tar.gz"
  sha256 "53a83ccc29b7475904a5495334a00d35c733878d2912f994c415e6d8dc2e61d5"

  bottle do
    sha256 "6afa7c230271ed8f36531f92acf9fe4264cb75fb369ce7fac664aba284ddb410" => :mojave
    sha256 "9358678158d18e9b026ae4aae671c985a17d49cf0c6103b863c0723ea4c0c2fb" => :high_sierra
    sha256 "c4f5291bb022e5729bb1e4d831080398de1dccc698a745323d3a90282894d99c" => :sierra
  end

  head do
    url "https://github.com/FreeTDS/freetds.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "unixodbc"
  uses_from_macos "readline"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-tdsver=7.3
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-unixodbc=#{Formula["unixodbc"].opt_prefix}
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
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
