class NetSnmp < Formula
  desc "Implements SNMP v1, v2c, and v3, using IPv4 and IPv6"
  homepage "http://www.net-snmp.org/"
  url "https://downloads.sourceforge.net/project/net-snmp/net-snmp/5.7.3/net-snmp-5.7.3.tar.gz"
  sha256 "12ef89613c7707dc96d13335f153c1921efc9d61d3708ef09f3fc4a7014fb4f0"

  bottle do
    rebuild 4
    sha256 "8b1d25d44cebfcb3cf64612a764610c2acf62f4e6615ab5805e4f2194b6724e1" => :sierra
    sha256 "30fd6c62d9ae9ab7865f9a35757a5795e39126a273e696f7d264bcf9e68745f3" => :el_capitan
    sha256 "31ea95b5df7f5299146e792e914ff54c4ab693469782eabfb23f427057827c6d" => :yosemite
  end

  keg_only :provided_by_osx

  depends_on "openssl"
  depends_on :python => :optional

  def install
    args = %W[
      --disable-debugging
      --prefix=#{prefix}
      --enable-ipv6
      --with-defaults
      --with-persistent-directory=#{var}/db/net-snmp
      --with-logfile=#{var}/log/snmpd.log
      --with-mib-modules=host\ ucd-snmp/diskio
      --without-rpm
      --without-kmem-usage
      --disable-embedded-perl
      --without-perl-modules
      --with-openssl=#{Formula["openssl"].opt_prefix}
    ]

    if build.with? "python"
      args << "--with-python-modules"
      ENV["PYTHONPROG"] = which("python")
    end

    # https://sourceforge.net/p/net-snmp/bugs/2504/
    ln_s "darwin13.h", "include/net-snmp/system/darwin14.h"
    ln_s "darwin13.h", "include/net-snmp/system/darwin15.h"
    ln_s "darwin13.h", "include/net-snmp/system/darwin16.h"
    ln_s "darwin13.h", "include/net-snmp/system/darwin17.h"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    (var/"db/net-snmp").mkpath
    (var/"log").mkpath
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snmpwalk -V 2>&1")
  end
end
