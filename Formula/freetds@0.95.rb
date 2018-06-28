class FreetdsAT095 < Formula
  desc "Libraries to talk to Microsoft SQL Server & Sybase"
  homepage "http://www.freetds.org/"
  url "http://www.freetds.org/files/stable/freetds-0.95.95.tar.gz"
  sha256 "be7c90fc771f30411eff6ae3a0d2e55961f23a950a4d93c44d4c488006e64c70"

  bottle do
    sha256 "68ca5f5fb65364ebb0c9d40ba55567f15c3ffd15e9f9e98242622a77004884b0" => :high_sierra
    sha256 "0b110cfa1802f0be1c2866abbfddf4a4f04c5c23e89e3edf254b9e1037f8c7a8" => :sierra
    sha256 "c404bdb3711d5f5a1c1821c908d35b30c4a0ebbc9f35c1791ae132ae00d5cd00" => :el_capitan
  end

  option "with-msdblib", "Enable Microsoft behavior in the DB-Library API where it diverges from Sybase's"
  option "with-sybase-compat", "Enable close compatibility with Sybase's ABI, at the expense of other features"
  option "with-odbc-wide", "Enable odbc wide, prevent unicode - MemoryError's"
  option "with-krb5", "Enable Kerberos support"

  deprecated_option "enable-msdblib" => "with-msdblib"
  deprecated_option "enable-sybase-compat" => "with-sybase-compat"
  deprecated_option "enable-odbc-wide" => "with-odbc-wide"
  deprecated_option "enable-krb" => "with-krb5"

  depends_on "pkg-config" => :build
  depends_on "openssl" => :recommended
  depends_on "unixodbc" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --with-tdsver=7.3
      --mandir=#{man}
    ]

    if build.with? "openssl"
      args << "--with-openssl=#{Formula["openssl"].opt_prefix}"
    end

    if build.with? "unixodbc"
      args << "--with-unixodbc=#{Formula["unixodbc"].opt_prefix}"
    end

    # Translate formula's "--with" options to configuration script's "--enable"
    # options
    %w[msdblib sybase-compat odbc-wide krb5].each do |option|
      if build.with? option
        args << "--enable-#{option}"
      end
    end

    system "./configure", *args
    system "make"
    ENV.deparallelize # Or fails to install on multi-core machines
    system "make", "install"
  end

  test do
    system "#{bin}/tsql", "-C"
  end
end
