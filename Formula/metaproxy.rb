class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/metaproxy"
  url "http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.11.6.tar.gz"
  sha256 "33c9a9bcba3abb5592b3c1671455dc0d0a5747d2df014726abd0518e98a9cb76"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "9d892d2dff7fcb190cf980c345eb580de52219fbf8e77e242d25cdff3315cee2" => :sierra
    sha256 "959140131fc284bf11e273e170d10a0ef7848842b434067e037633ad7fc3d933" => :el_capitan
    sha256 "e0ccbe21c234894ae58d1d44de802dbba851be14e9b03def53ce6dd6f2f2cb44" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "yazpp"
  depends_on "boost"

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
