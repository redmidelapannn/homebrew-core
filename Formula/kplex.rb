class Kplex < Formula
  desc "NMEA 0183 multiplexer"
  homepage "http://www.stripydog.com/kplex/"
  url "https://github.com/stripydog/kplex/archive/v1.3.4.tar.gz"
  sha256 "a2a3e48971b7154b2769c30e7943ed8370ee5f359c66bcba11b88b87fa2b1b35"
  head "https://github.com/stripydog/kplex.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "164e463f1b2844ba61188a8298386010759625eb27e68a4e5f8f9b31844fe3c3" => :sierra
    sha256 "19044dbed211e7a3b2163f3137497f5a16c350a0c51387aaec2e57a11d0f4ce9" => :el_capitan
    sha256 "a3d07b5fef848bb6a9f101f0485ec626dab0d62e371aaaa4f5690ebd2c646b3e" => :yosemite
  end

  def install
    # kplex's make install target tries chowning and chmodding the binary,
    # so just make and then copy the binary into place ourselves.
    system "make"
    bin.install "kplex"

    # Copy the example config file into the prefix so the user can copy it.
    prefix.install "kplex.conf.ex"
  end

  def caveats; <<-EOS.undent
    A sample config file can be found at "#{prefix}/kplex.conf.ex".
    Kplex will look for per-user config at "~/Library/Preferences/kplex.ini"
    or a system-wide config file at "/etc/kplex.conf".

    You can copy the example config file to your user directory with the
    following command:
    $ cp #{prefix}/kplex.conf.ex ~/Library/Preferences/kplex.ini

    See http://www.stripydog.com/kplex/configuration.html for config details.

    If you want to run kplex as a service, you will need to create a config
    file before starting the service.
    EOS
  end

  plist_options :manual => "kplex"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/kplex</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/kplex", "-V"
  end
end
