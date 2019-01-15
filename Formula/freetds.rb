class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "http://www.freetds.org/"
  url "http://www.freetds.org/files/stable/freetds-1.00.109.tar.gz"
  sha256 "314cc6c22086dc2cc677aed5e0dec07845cf13f79273af7bb855eb447b45f906"

  bottle do
    rebuild 1
    sha256 "cf6f2a0876afc8895d3b64c6429050489790f6a3064542abca51a6fd8a7075f6" => :mojave
    sha256 "65adeae4e0670b49af50e597c471a514acd94b759c65364a976ca976e970baab" => :high_sierra
    sha256 "0572a8e4b20c019fcdcc10b097d747d5a250590810ab537192a6150e2a89a848" => :sierra
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
