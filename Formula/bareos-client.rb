class BareosClient < Formula
  desc "Client for Bareos (Backup Archiving REcovery Open Sourced)"
  homepage "https://www.bareos.org/"
  url "https://github.com/bareos/bareos/archive/Release/17.2.6.tar.gz"
  sha256 "b35c6c51cee095b63ceaa5250ca25dfe3cc11f92fbeada6c6bc4e1d79d28087a"

  bottle do
    sha256 "56284f8a1251c3315eeb10e4e96f34bb89f6a59f94bf7a7110ed1a0470d4ef02" => :high_sierra
    sha256 "047fe3b9513da9f3a7d64e58e9f193418f8e6305b1a10e7663d2ab0d18f53274" => :sierra
    sha256 "1970bc09a865d10146c779edb9aed7a4e9cf7772f10ffc0b026e03664849c724" => :el_capitan
  end

  depends_on "openssl"
  depends_on "readline"

  conflicts_with "bacula-fd",
    :because => "Both install a `bconsole` executable."

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-working-dir=#{var}/lib/bareos",
                          "--with-archivedir=#{var}/bareos",
                          "--with-confdir=#{etc}/bareos",
                          "--with-configtemplatedir=#{lib}/bareos/defaultconfigs",
                          "--with-scriptdir=#{lib}/bareos/scripts",
                          "--with-plugindir=#{lib}/bareos/plugins",
                          "--with-fd-password=XXX_REPLACE_WITH_CLIENT_PASSWORD_XXX",
                          "--with-mon-fd-password=XXX_REPLACE_WITH_CLIENT_MONITOR_PASSWORD_XXX",
                          "--with-basename=XXX_REPLACE_WITH_LOCAL_HOSTNAME_XXX",
                          "--with-hostname=XXX_REPLACE_WITH_LOCAL_HOSTNAME_XXX",
                          "--with-python",
                          "--enable-client-only"

    # The file platforms/osx/Makefile is intended for other environment (not homebrew)
    # and would break the build process.
    # Therefore it is removed until this has been fixed upstream,
    # see https://bugs.bareos.org/view.php?id=900
    rm "platforms/osx/Makefile"

    system "make", "install"
  end

  def post_install
    # If no configuration files are present,
    # deploy them (copy them and replace variables).
    unless (etc/"bareos/bareos-fd.d").exist?
      system lib/"bareos/scripts/bareos-config", "deploy_config",
             lib/"bareos/defaultconfigs", etc/"bareos", "bareos-fd"
      system lib/"bareos/scripts/bareos-config", "deploy_config",
             lib/"bareos/defaultconfigs", etc/"bareos", "bconsole"
    end
  end

  plist_options :startup => true

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/bareos-fd</string>
          <string>-f</string>
        </array>
        <key>StandardOutPath</key>
        <string>#{var}/run/bareos-fd.log</string>
        <key>StandardErrorPath</key>
        <string>#{var}/run/bareos.log</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    # Check if bareos-fd starts at all.
    assert_match version.to_s, shell_output("#{sbin}/bareos-fd -? 2>&1", 1)
    # Check if the configuration is valid.
    system sbin/"bareos-fd", "-t"
  end
end
