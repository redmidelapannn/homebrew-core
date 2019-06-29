class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.1.6.tar.gz"
  sha256 "f3ce8e48bc8fd08777a35c7fc0a26b6c8e7e53748c8c0afec49231df93afcdee"

  bottle do
    rebuild 1
    sha256 "dcecf18e348acc7514ca1bc2ee15cd9be49f5c66e277124cdaa0becc98d528b7" => :mojave
    sha256 "c8e6d4eab84584db39476b5f5c4e77230faedb02a2947fd511cea4651391e2eb" => :high_sierra
    sha256 "a14275c22cc52525856f69fb534c2938da1b217b035ad9f6a0124e07f14f9910" => :sierra
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
