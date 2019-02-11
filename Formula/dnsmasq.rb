class Dnsmasq < Formula
  desc "Lightweight DNS forwarder and DHCP server"
  homepage "http://www.thekelleys.org.uk/dnsmasq/doc.html"
  url "http://www.thekelleys.org.uk/dnsmasq/dnsmasq-2.80.tar.gz"
  sha256 "9e4a58f816ce0033ce383c549b7d4058ad9b823968d352d2b76614f83ea39adc"

  bottle do
    rebuild 2
    sha256 "259506592d1300703a3e62857ffccf77fb68a51d2a2fb4b13a7f90da2edf91e8" => :mojave
    sha256 "b90d1870b40195265a1c630eda229454484abb2c49ba4efe3998b0efb28be7a1" => :high_sierra
    sha256 "b1ad56a726d21a8dc763a85082218d8f48a3ec89fc8412e78ed556a040621ec5" => :sierra
  end

  depends_on "pkg-config" => :build

  def install
    ENV.deparallelize

    # Fix etc location
    inreplace %w[dnsmasq.conf.example src/config.h man/dnsmasq.8
                 man/es/dnsmasq.8 man/fr/dnsmasq.8].each do |s|
      s.gsub! "/var/lib/misc/dnsmasq.leases",
              var/"lib/misc/dnsmasq/dnsmasq.leases", false
      s.gsub! "/etc/dnsmasq.conf", etc/"dnsmasq.conf", false
      s.gsub! "/var/run/dnsmasq.pid", var/"run/dnsmasq/dnsmasq.pid", false
      s.gsub! "/etc/dnsmasq.d", etc/"dnsmasq.d", false
      s.gsub! "/etc/ppp/resolv.conf", etc/"dnsmasq.d/ppp/resolv.conf", false
      s.gsub! "/etc/dhcpc/resolv.conf", etc/"dnsmasq.d/dhcpc/resolv.conf", false
      s.gsub! "/usr/sbin/dnsmasq", HOMEBREW_PREFIX/"sbin/dnsmasq", false
    end

    # Fix compilation on newer macOS versions.
    ENV.append_to_cflags "-D__APPLE_USE_RFC_3542"

    inreplace "Makefile" do |s|
      s.change_make_var! "CFLAGS", ENV.cflags
      s.change_make_var! "LDFLAGS", ENV.ldflags
    end

    system "make", "install", "PREFIX=#{prefix}"

    etc.install "dnsmasq.conf.example" => "dnsmasq.conf"
  end

  def post_install
    (var/"lib/misc/dnsmasq").mkpath
    (var/"run/dnsmasq").mkpath
    (etc/"dnsmasq.d/ppp").mkpath
    (etc/"dnsmasq.d/dhcpc").mkpath
  end

  plist_options :startup => true

  def plist
    {
      :Label            => plist_name,
      :ProgramArguments => %w[#{opt_sbin}/dnsmasq --keep-in-foreground -C #{etc}/dnsmasq.conf],
      :RunAtLoad        => true,
      :KeepAlive        => true,
    }
  end

  test do
    system "#{sbin}/dnsmasq", "--test"
  end
end
