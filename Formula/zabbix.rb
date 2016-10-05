class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/3.0.1/zabbix-3.0.1.tar.gz"
  sha256 "e91a8497bf635b96340988e2d9ca1bb3fac06e657b6596fa903c417a6c6b110b"
  revision 1

  bottle do
    sha256 "00a5b0060bd23f97bf3dc3dfe9e5d69e2cd4d00fe8de12d1baeb2fb352b3d920" => :sierra
    sha256 "d241a2430578d09154dbfdf6c0bc8c24dd955d257da8ea43b1e8aefbe946013e" => :el_capitan
    sha256 "f5b742442adb90a77d242fefd2f4761fc4ba5b8313c057d0f57a55b2bb318522" => :yosemite
  end

  option "with-mysql", "Use Zabbix Server with MySQL library instead PostgreSQL."
  option "without-server-proxy", "Install only the Zabbix Agent without Server and Proxy."

  deprecated_option "agent-only" => "without-server-proxy"

  if build.with? "server-proxy"
    depends_on :mysql => :optional
    depends_on :postgresql if build.without? "mysql"
    depends_on "fping"
    depends_on "libssh2"
  end

  def brewed_or_shipped(db_config)
    brewed_db_config = "#{HOMEBREW_PREFIX}/bin/#{db_config}"
    (File.exist?(brewed_db_config) && brewed_db_config) || which(db_config)
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-agent
      --with-iconv=#{MacOS.sdk_path}/usr
    ]

    if build.with? "server-proxy"
      args += %W[
        --enable-server
        --enable-proxy
        --enable-ipv6
        --with-net-snmp
        --with-libcurl
        --with-ssh2
      ]

      if build.with? "mysql"
        args << "--with-mysql=#{brewed_or_shipped("mysql_config")}"
      else
        args << "--with-postgresql=#{brewed_or_shipped("pg_config")}"
      end
    end

    system "./configure", *args
    system "make", "install"

    if build.with? "server-proxy"
      db = build.with?("mysql") ? "mysql" : "postgresql"
      pkgshare.install "frontends/php", "database/#{db}"
    end
  end

  test do
    system "#{sbin}/zabbix_agentd", "--print"
  end
end
