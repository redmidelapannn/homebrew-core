class Gpsd < Formula
  desc "Global Positioning System (GPS) daemon"
  homepage "http://catb.org/gpsd/"
  url "https://download.savannah.gnu.org/releases/gpsd/gpsd-3.17.tar.gz"
  sha256 "68e0dbecfb5831997f8b3d6ba48aed812eb465d8c0089420ab68f9ce4d85e77a"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ca4fbe6ec6c72072c44b0052e6b2188d1cdeb471f41ff18d6fb1f343aa46b132" => :high_sierra
    sha256 "ddbf5536f6bcce3daf08c85887c31bf2e5fee76f71e1c0fc39cfb2ba2347fcdf" => :sierra
    sha256 "a8723a886362151ee5bf8beb639e58ea712d39f331af45cc506c0173fdefc343" => :el_capitan
  end

  depends_on "scons" => :build
  depends_on "libusb" => :optional

  def install
    scons "chrpath=False", "python=False", "strip=False", "prefix=#{prefix}/"
    scons "install"
  end

  def caveats; <<-EOS.undent
    This Formula for gpsd comes with support for auto-starting gpsd using
    `brew services start gpsd`. However, this version of gpsd does not
    automatically detect GPS device addresses.

    Once started, you need to use gpsdctl to force gpsd to connect to your GPS:

      GPSD_SOCKET="#{var}/gpsd.sock" #{HOMEBREW_PREFIX}/sbin/gpsdctl add /dev/tty.usbserial-XYZ

    Once running, anything that can connect to `localhost` on your Mac can see
    your physical location, regardless of location permissions!
    EOS
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/sbin/gpsd -N -F #{HOMEBREW_PREFIX}/var/gpsd.sock /dev/tty.usbserial-XYZ"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/gpsd</string>
        <string>-N</string>
        <string>-F</string>
        <string>#{var}/gpsd.sock</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/gpsd.log</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/gpsd.log</string>
    </dict>
    </plist>
    EOS
  end

  test do
    assert_equal "#{sbin}/gpsd: 3.17 (revision 3.17)", shell_output("#{sbin}/gpsd -V").chomp
  end
end
