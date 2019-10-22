class Vsftpd < Formula
  desc "Secure FTP server for UNIX"
  homepage "https://security.appspot.com/vsftpd.html"
  url "https://security.appspot.com/downloads/vsftpd-3.0.3.tar.gz"
  mirror "https://fossies.org/linux/misc/vsftpd-3.0.3.tar.gz"
  sha256 "9d4d2bf6e6e2884852ba4e69e157a2cecd68c5a7635d66a3a8cf8d898c955ef7"

  bottle do
    rebuild 3
    sha256 "d2274d01c0069b8130399af5a59a2326526b598d31a19028b71b0c3bab2557f8" => :catalina
    sha256 "f8b87aeacccee43a0a378f6649ecf58ecf161fcab840fd6c25ff1c53d3347762" => :mojave
    sha256 "2517595ad0358b69908c07d6dd1b0089734cfb198745f2cc03df703380f1e53e" => :high_sierra
  end

  # Patch to remove UTMPX dependency, locate macOS's PAM library, and
  # remove incompatible LDFLAGS. (reported to developer via email)
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/vsftpd/3.0.3.patch"
    sha256 "7947d91f75cb02b834783382bcd2a2ef41565a76e31a5667a1ea0bd5bef48011"
  end

  def install
    inreplace "defs.h", "/etc/vsftpd.conf", "#{etc}/vsftpd.conf"
    inreplace "tunables.c", "/etc", etc
    inreplace "tunables.c", "/var", var
    system "make"

    # make install has all the paths hardcoded; this is easier:
    sbin.install "vsftpd"
    etc.install "vsftpd.conf"
    man5.install "vsftpd.conf.5"
    man8.install "vsftpd.8"
  end

  def caveats; <<~EOS
    To use chroot, vsftpd requires root privileges, so you will need to run
    `sudo vsftpd`.
    You should be certain that you trust any software you grant root privileges.

    The vsftpd.conf file must be owned by root or vsftpd will refuse to start:
      sudo chown root #{HOMEBREW_PREFIX}/etc/vsftpd.conf
  EOS
  end

  plist_options :startup => true, :manual => "sudo vsftpd"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{sbin}/vsftpd</string>
        <string>#{etc}/vsftpd.conf</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
  EOS
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/vsftpd -v 0>&1")
  end
end
