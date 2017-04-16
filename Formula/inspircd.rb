class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/v2.0.23.tar.gz"
  sha256 "522b31fc80e8fd90b66837bf50f8a941233709d5b1fc9c0b3c47a413fb69f162"
  head "https://github.com/inspircd/inspircd.git", :branch => "insp20"

  bottle do
    rebuild 1
    sha256 "ad57acde9b3c383e5d709c85391fab4c6dbfbfb8112bbdf0601d6475788392d3" => :sierra
    sha256 "395982223c05e2c69d8255d9949cedb09ef610e34aa90b96236e94697c8df6b9" => :el_capitan
    sha256 "69e6708f430efd5e31fceb18dcd3b63409c33860bf5bfee501bf80ff2dcebc56" => :yosemite
  end

  skip_clean "data"
  skip_clean "logs"

  option "without-ldap", "Build without ldap support"

  depends_on "pkg-config" => :build
  depends_on "geoip" => :optional
  depends_on "gnutls" => :optional
  depends_on :mysql => :optional
  depends_on "openssl" => :optional
  depends_on "pcre" => :optional
  depends_on "postgresql" => :optional
  depends_on "sqlite" => :optional
  depends_on "tre" => :optional

  def install
    modules = []
    modules << "m_geoip.cpp" if build.with? "geoip"
    modules << "m_ssl_gnutls.cpp" if build.with? "gnutls"
    modules << "m_mysql.cpp" if build.with? "mysql"
    modules << "m_ssl_openssl.cpp" if build.with? "openssl"
    modules << "m_ldapauth.cpp" << "m_ldapoper.cpp" if build.with? "ldap"
    modules << "m_regex_pcre.cpp" if build.with? "pcre"
    modules << "m_pgsql.cpp" if build.with? "postgresql"
    modules << "m_sqlite3.cpp" if build.with? "sqlite"
    modules << "m_regex_tre.cpp" if build.with? "tre"

    system "./configure", "--enable-extras=#{modules.join(",")}" unless modules.empty?
    system "./configure", "--prefix=#{prefix}", "--with-cc=#{ENV.cc}"
    system "make", "install"
  end

  def post_install
    inreplace "#{prefix}/org.inspircd.plist", "ircdaemon", ENV["USER"]
  end

  test do
    system "#{bin}/inspircd", "--version"
  end
end
