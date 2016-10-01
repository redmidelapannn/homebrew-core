class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/metaproxy"
  url "http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.10.0.tar.gz"
  sha256 "83a282a9aefa71fd073adc2ef1c474e8b594c921da0c2c4b977821bfc3cf5a5e"
  revision 3

  bottle do
    cellar :any
    sha256 "50160800a581fbbf8d278f4ed11131d6ed38b5400125d53926692c7faa0c6759" => :sierra
    sha256 "f514b0fa08e306e9cc3997653a39f95ba8b98e6eda959c14a516513221d434d3" => :el_capitan
    sha256 "7c815d4fd40eeaecda73127ade9accbc9375fc80e3b591bcaa00c93f35a2a244" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "yazpp"
  depends_on "boost@1.61"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  # Test by making metaproxy test a trivial configuration file (etc/config0.xml).
  test do
    (testpath/"test-config.xml").write <<-EOS.undent
    <?xml version="1.0"?>
    <metaproxy xmlns="http://indexdata.com/metaproxy" version="1.0">
      <start route="start"/>
      <filters>
        <filter id="frontend" type="frontend_net">
          <port max_recv_bytes="1000000">@:9070</port>
          <message>FN</message>
          <stat-req>/fn_stat</stat-req>
        </filter>
      </filters>
      <routes>
        <route id="start">
          <filter refid="frontend"/>
          <filter type="log"><category access="false" line="true" apdu="true" /></filter>
          <filter type="backend_test"/>
          <filter type="bounce"/>
        </route>
      </routes>
    </metaproxy>
    EOS

    system "#{bin}/metaproxy", "-t", "--config", "#{testpath}/test-config.xml"
  end
end
