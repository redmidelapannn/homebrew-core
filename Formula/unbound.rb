class Unbound < Formula
  desc "Validating, recursive, caching DNS resolver"
  homepage "https://www.unbound.net"
  url "https://unbound.net/downloads/unbound-1.5.9.tar.gz"
  sha256 "01328cfac99ab5b8c47115151896a244979e442e284eb962c0ea84b7782b6990"

  bottle do
    cellar :any
    sha256 "0f28319d0b163d5fb55b967aed092c47e2f9d2ea45e4262d9047ff45ae9bdfad" => :el_capitan
    sha256 "90c78fbbdb2a09e39de477511e8adb68959eb4cd988e5da075bf2ec057a77c80" => :yosemite
    sha256 "ccd0594c950f5ba71770a48b2a5cad80e3bb9fc06f37b4df69186f10702d7d21" => :mavericks
  end

  depends_on "openssl"
  depends_on "libevent"
  depends_on "expat"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-libevent=#{Formula["libevent"].opt_prefix}",
                          "--with-libexpat=#{Formula["expat"].opt_prefix}",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}"
    inreplace "doc/example.conf", 'username: "unbound"', 'username: "@@HOMEBREW-UNBOUND-USER@@"'
    system "make", "install"
  end

  def post_install
    if File.read(etc/"unbound/unbound.conf").include?('username: "@@HOMEBREW-UNBOUND-USER@@"')
      inreplace etc/"unbound/unbound.conf", 'username: "@@HOMEBREW-UNBOUND-USER@@"', "username: \"#{ENV["USER"]}\""
    end
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-/Apple/DTD PLIST 1.0/EN" "http:/www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>KeepAlive</key>
        <true/>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/unbound</string>
          <string>-d</string>
          <string>-c</string>
          <string>#{etc}/unbound/unbound.conf</string>
        </array>
        <key>UserName</key>
        <string>root</string>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system sbin/"unbound-control-setup", "-d", testpath
  end
end
