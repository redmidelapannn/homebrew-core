class Fail2ban < Formula
  desc "Scan log files and ban IPs showing malicious signs"
  homepage "https://www.fail2ban.org/"
  url "https://github.com/fail2ban/fail2ban/archive/0.9.6.tar.gz"
  sha256 "1712e4eda469513fb2f44951957a4159e0fa62cb9da16ed48e7f4f4037f0b976"

  bottle do
    cellar :any_skip_relocation
    sha256 "13261586fa003d3b6517b12a8eb65f78742f23688671a7ce995ba5b6eef990f2" => :sierra
    sha256 "212776feaf0b0a11e310f9f84970071d5455247a3a66a9b4641b24adfa2211d2" => :el_capitan
    sha256 "212776feaf0b0a11e310f9f84970071d5455247a3a66a9b4641b24adfa2211d2" => :yosemite
  end

  depends_on :python

  def install
    rm "setup.cfg"
    inreplace "setup.py" do |s|
      s.gsub! %r{/etc}, etc
      s.gsub! %r{/var}, var
    end

    inreplace "bin/fail2ban-client", "/etc", etc

    inreplace "bin/fail2ban-server", "/var", var
    inreplace "config/fail2ban.conf", "/var/run", (var/"run")

    inreplace "setup.py", "/usr/share/doc/fail2ban", (libexec/"doc")

    system "python", *Language::Python.setup_install_args(prefix)
  end

  def caveats
    <<-EOS.undent
      Before using Fail2Ban for the first time you should edit jail
      configuration and enable the jails that you want to use, for instance
      ssh-ipfw. Also make sure that they point to the correct configuration
      path. I.e. on Mountain Lion the sshd logfile should point to
      /var/log/system.log.

        * #{etc}/fail2ban/jail.conf

      The Fail2Ban wiki has two pages with instructions for macOS Server that
      describes how to set up the Jails for the standard macOS Server
      services for the respective releases.

        10.4: https://www.fail2ban.org/wiki/index.php/HOWTO_Mac_OS_X_Server_(10.4)
        10.5: https://www.fail2ban.org/wiki/index.php/HOWTO_Mac_OS_X_Server_(10.5)
    EOS
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/fail2ban-client</string>
          <string>-x</string>
          <string>start</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    system bin/"fail2ban-client", "-h"
    system bin/"fail2ban-server", "-h"
  end
end
