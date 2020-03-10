class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.4.0.tar.bz2"
  sha256 "a336fa2c3eb381c2464d9d9790014fd6d4505029ed2c1b73ee1dc9115a2f1dc0"

  bottle do
    cellar :any
    sha256 "7521eb7725e047e14849c1d9a721252b481c4b525dd3e87f0c44128ebf7a7a2b" => :high_sierra
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

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
