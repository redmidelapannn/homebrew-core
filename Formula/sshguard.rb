class Sshguard < Formula
  desc "Protect from brute force attacks against SSH"
  homepage "https://www.sshguard.net/"
  url "https://downloads.sourceforge.net/project/sshguard/sshguard/2.0.0/sshguard-2.0.0.tar.gz"
  sha256 "e87c6c4a6dddf06f440ea76464eb6197869c0293f0a60ffa51f8a6a0d7b0cb06"
  revision 1
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "4d8e5e10d59d5a938effafee2823c4bb902cc771752bb7b314313a3b53fa8b71" => :sierra
    sha256 "836b4489e895da154694d8c6b84019ac997c104aab5e89121a885730bc887d0d" => :el_capitan
    sha256 "b415c117d6d73a477fc5a9d7f43ef160dc7ac88171f433ed1f5183d7a921e4f8" => :yosemite
  end

  head do
    url "https://bitbucket.org/sshguard/sshguard.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "docutils" => :build
  end

  def install
    system "autoreconf", "-fiv" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
    cp "examples/sshguard.conf.sample", "examples/sshguard.conf"
    inreplace "examples/sshguard.conf" do |s|
      s.gsub! /^#BACKEND=.*$/, "BACKEND=\"#{opt_libexec}/sshg-fw-#{firewall}\""
      if MacOS.version >= :sierra
        s.gsub! %r{^#LOGREADER="/usr/bin/log}, "LOGREADER=\"/usr/bin/log"
      else
        s.gsub! /^#FILES.*$/, "FILES=#{log_path}"
      end
    end
    etc.install "examples/sshguard.conf"
  end

  def firewall
    (MacOS.version >= :lion) ? "pf" : "ipfw"
  end

  def log_path
    (MacOS.version >= :lion) ? "/var/log/system.log" : "/var/log/secure.log"
  end

  def caveats
    if MacOS.version >= :lion then <<-EOS.undent
      Add the following lines to /etc/pf.conf to block entries in the sshguard
      table (replace $ext_if with your WAN interface):

        table <sshguard> persist
        block in quick on $ext_if proto tcp from <sshguard> to any port 22 label "ssh bruteforce"

      Then run sudo pfctl -f /etc/pf.conf to reload the rules.
      EOS
    end
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>KeepAlive</key>
      <true/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/sshguard</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    assert_match "SSHGuard #{version}", shell_output("#{sbin}/sshguard -v 2>&1")
  end
end
