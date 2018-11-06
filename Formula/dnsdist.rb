class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.3.2.tar.bz2"
  sha256 "0be7704e5a418a8ed6908fc110ecfb9bc23f270b5af8a5525f1fa934ef0e6bc4"
  revision 1

  bottle do
    sha256 "4b48ad4caf61e59e1a4011907b292c7da7e3d5f8078afe5400b3bc23f3402cb0" => :mojave
    sha256 "c057b237fb01fae219255ff3ce83c1f87b68d7a5bd7bcd2d2bf7d72bf5ae714b" => :sierra
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  def install
    # error: unknown type name 'mach_port_t'
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra || MacOS.version == :high_sierra

    if MacOS.version >= :high_sierra
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
