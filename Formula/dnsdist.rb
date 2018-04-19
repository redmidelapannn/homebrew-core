class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.3.0.tar.bz2"
  sha256 "aa67cd4db8404a13ed4ed1097dd850203dab8a327372f72bb140df11ef7eba08"

  bottle do
    rebuild 1
    sha256 "10f33433313b4b4392fdb7566e5220d6d4ab99916d75b79a06083cca73545c7d" => :high_sierra
    sha256 "1f6079ef588b8a03dfd6872eb76ea0c3df76b7161f7b83a62641ff90c7e9644b" => :sierra
    sha256 "0f7ae483f62238e9f3d1117ec567236b4bd73832f1919c5553c887ad8c39c3f3" => :el_capitan
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  # Remove for > 1.3.0
  # Boost 1.67 compatibility; backported by Jan Beich in FreeBSD
  # Upstream fix from 16 Mar 2018 "Logging: have a global g_log"
  # See https://github.com/PowerDNS/pdns/commit/e6a9dde524b57bb57f1d063ef195bb1e2667c5fc
  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/6fa3dca03cf2e321018d6894ddce6f7f33b64305/dns/dnsdist/files/patch-boost-1.67"
    sha256 "58f2e42ccd55e97429e3692aeeda6c9f24e4c4300bf384eaffc12ac3e8079dfb"
  end

  def install
    # error: unknown type name 'mach_port_t'
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    if MacOS.version == :high_sierra
      sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path
      ENV["LIBEDIT_CFLAGS"] = "-I#{sdk}/usr/include -I#{sdk}/usr/include/editline"
      ENV["LIBEDIT_LIBS"] = "-L/usr/lib -ledit -lcurses"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-net-snmp",
                          "--sysconfdir=#{etc}/dnsdist"
    system "make", "install"
  end

  test do
    (testpath/"dnsdist.conf").write "setLocal('127.0.0.1')"
    output = shell_output("#{bin}/dnsdist -C dnsdist.conf --check-config 2>&1")
    assert_equal "Configuration 'dnsdist.conf' OK!", output.chomp
  end
end
