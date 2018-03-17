class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.6.0.tar.gz"
  sha256 "205ab5ac512cbeee3c7a6f693518420ae66d6414c1d27247d002167e1906d6d3"

  bottle do
    rebuild 1
    sha256 "a7e9bb64192f1612508bc06837e4c0a2ea28df897ed6633e5f0ced3f5967bef6" => :high_sierra
    sha256 "bce016d47a7fe474a15b1e5312c78dfba5e856841cf4dcf2e94475251f67dc5b" => :sierra
    sha256 "b2bdce9246071c346bf3127327356ececa8c782f8632bdbc372bd89901b24467" => :el_capitan
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  plist_options :manual => "openfortivpn --config #{HOMEBREW_PREFIX}/etc/openfortivpn/config"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/openfortivpn</string>
        <string>--config</string>
        <string>#{etc}/openfortivpn/config</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <false/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/openfortivpn.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/openfortivpn.log</string>
    </dict>
    </plist>
    EOS
  end

  test do
    system bin/"openfortivpn", "--version"
  end
end
