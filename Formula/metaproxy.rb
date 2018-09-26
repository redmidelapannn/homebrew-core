class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/metaproxy"
  url "http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.13.0.tar.gz"
  sha256 "ed3d40058e0e36141bea7d7f0e39733a7b7409281cdf6a60be90186d412c2be1"
  revision 3

  bottle do
    cellar :any
    sha256 "a6e11f1accda2f848f54a662ba52f9f73b3581a01636c7942d3cb9eb1381c245" => :mojave
    sha256 "5f4446924dd64fc85a8d73633ccf2fd76328d3ec6e444dcffa3029704944669c" => :high_sierra
    sha256 "673b3c5a3933b126843abb886dccbd1ac6b8d455002ab4f2672397dfac63d495" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "yazpp"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  # Test by making metaproxy test a trivial configuration file (etc/config0.xml).
  test do
    (testpath/"test-config.xml").write <<~EOS
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
