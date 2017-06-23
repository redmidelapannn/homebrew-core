class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.0.3.tar.bz2"
  sha256 "60fa21550b278b41f58701af31c9f2b121badf271fb9d7642f6d35bfbea8e282"
  revision 1

  bottle do
    sha256 "b84a7652aaab4986bcef982949786a172a791ee31013dc9d28eb459f7f6e2185" => :sierra
    sha256 "54ec26f92fd6a5e54503a1e88e4fb7e4eb474a9f0d15481daf57d54ecf035d1e" => :el_capitan
    sha256 "a5c2df448ede155bda86e1171d1dbfcd24a423a774b43c91e1f5b5200ec8eb53" => :yosemite
  end

  head do
    url "https://github.com/powerdns/pdns.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool"  => :build
    depends_on "ragel"
  end

  option "with-postgresql", "Enable the PostgreSQL backend"

  deprecated_option "pgsql" => "with-postgresql"
  deprecated_option "with-pgsql" => "with-postgresql"

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl"
  depends_on "sqlite"
  depends_on :postgresql => :optional
  
  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/pdns
      --localstatedir=#{var}
      --with-socketdir=#{var}/run
      --with-lua
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --with-sqlite3
    ]

    # default backend modules
    module_list="--with-modules=bind gsqlite3"

    # Include the PostgreSQL backend if requested
    # ( This pattern can be adapted to additional optional modules.  Just remember to
    # include a space in front of the module name )
    module_list << " gpgsql" if build.with? "postgresql"
    args << module_list

    system "./bootstrap" if build.head?
    system "./configure", *args

    system "make", "install"
    (var/"log/pdns").mkpath
    (var/"run").mkpath
  end

  plist_options :startup => true, :manual => "sudo pdns_server"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/pdns_server</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <dict>
        <key>Crashed</key>
        <true/>
      </dict>
      <key>StandardErrorPath</key>
      <string>#{var}/log/pdns/pdns_server.err</string>
      <key>StandardOutPath</key>
      <string>/dev/null</string>
    </dict>
    </plist>
    EOS
  end

  test do
    output = shell_output("#{sbin}/pdns_server --version 2>&1", 99)
    assert_match "PowerDNS Authoritative Server #{version}", output
  end
end
