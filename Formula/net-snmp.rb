class NetSnmp < Formula
  desc "Implements SNMP v1, v2c, and v3, using IPv4 and IPv6"
  homepage "http://www.net-snmp.org/"
  url "https://downloads.sourceforge.net/project/net-snmp/net-snmp/5.7.3/net-snmp-5.7.3.tar.gz"
  sha256 "12ef89613c7707dc96d13335f153c1921efc9d61d3708ef09f3fc4a7014fb4f0"

  bottle do
    revision 3
    sha256 "df576d6728be215262ac9eb71f1ee2e37183f1bfb20cb9bd57318003b4169b9f" => :el_capitan
    sha256 "aaf87413336725b61fb54942cf8fe35e42604c053ff200f37be65d37306e7098" => :yosemite
    sha256 "e8dc116be2380bf8a1a66da7074b990303145b217a600558d5db683da1d19e2b" => :mavericks
  end

  keg_only :provided_by_osx

  depends_on "openssl"
  depends_on :python => :optional

  def install
    args = [
      "--disable-debugging",
      "--prefix=#{prefix}",
      "--enable-ipv6",
      "--with-defaults",
      "--with-persistent-directory=#{var}/db/net-snmp",
      "--with-logfile=#{var}/log/snmpd.log",
      "--with-mib-modules=host ucd-snmp/diskio",
      "--without-rpm",
      "--without-kmem-usage",
      "--disable-embedded-perl",
      "--without-perl-modules",
    ]

    if build.with? "python"
      args << "--with-python-modules"
      ENV["PYTHONPROG"] = `which python`
    end

    # https://sourceforge.net/p/net-snmp/bugs/2504/
    ln_s "darwin13.h", "include/net-snmp/system/darwin14.h"
    ln_s "darwin13.h", "include/net-snmp/system/darwin15.h"
    ln_s "darwin13.h", "include/net-snmp/system/darwin16.h"

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
