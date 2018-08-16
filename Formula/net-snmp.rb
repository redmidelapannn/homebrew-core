class NetSnmp < Formula
  desc "Implements SNMP v1, v2c, and v3, using IPv4 and IPv6"
  homepage "http://www.net-snmp.org/"
  url "https://downloads.sourceforge.net/project/net-snmp/net-snmp/5.8/net-snmp-5.8.tar.gz"
  sha256 "b2fc3500840ebe532734c4786b0da4ef0a5f67e51ef4c86b3345d697e4976adf"

  bottle do
    rebuild 1
    sha256 "8eea275086e0d9f7881e0def2f31007734b5de5471921f8771338a8d112bb421" => :high_sierra
    sha256 "bde4c456a2f73f9525c996ac1527454e75e02f87f10308b393a525a169e5262f" => :sierra
    sha256 "6ee1bc47916fcbf8120038ea533b46618891a321fa2f7b9acb3e8b18e3950fe3" => :el_capitan
  end

  keg_only :provided_by_macos

  deprecated_option "with-python" => "with-python@2"

  depends_on "openssl"
  depends_on "python@2" => :optional

  def install
    # https://sourceforge.net/p/net-snmp/bugs/2504/
    # I suspect upstream will fix this in the first post-Mojave release but
    # if it's not fixed in that release this should be reported upstream.
    (buildpath/"include/net-snmp/system/darwin18.h").write <<~EOS
      #include <net-snmp/system/darwin17.h>
    EOS

    args = %W[
      --disable-debugging
      --prefix=#{prefix}
      --enable-ipv6
      --with-defaults
      --with-persistent-directory=#{var}/db/net-snmp
      --with-logfile=#{var}/log/snmpd.log
      --with-mib-modules=host\ ucd-snmp/diskio
      --without-rpm
      --without-kmem-usage
      --disable-embedded-perl
      --without-perl-modules
      --with-openssl=#{Formula["openssl"].opt_prefix}
    ]

    if build.with? "python@2"
      args << "--with-python-modules"
      ENV["PYTHONPROG"] = which("python2.7")
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    (var/"db/net-snmp").mkpath
    (var/"log").mkpath
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snmpwalk -V 2>&1")
  end
end
