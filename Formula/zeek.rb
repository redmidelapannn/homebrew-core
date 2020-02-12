class Zeek < Formula
  desc "Network security monitor"
  homepage "https://www.zeek.org"
  url "https://github.com/zeek/zeek.git",
      :tag      => "v3.0.1",
      :revision => "ae4740fa265701f494df23b65af80822f3e26a13"
  revision 1
  head "https://github.com/zeek/zeek.git"

  bottle do
    rebuild 1
    sha256 "de6112f5bb7de25776707a387954d3bc42553b75366d23528907dbc7c04fb3e0" => :catalina
    sha256 "90bd152043f8fb6a82f4debc65cd593f78df47ae95ada0760bfc50cc2e539c5e" => :mojave
    sha256 "8ade118b2c76c4b7345ae19f307f4142f239066794ffcc7ffd135d5386e0c2bf" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "caf"
  depends_on "geoip"
  depends_on "openssl@1.1"

  uses_from_macos "flex"
  uses_from_macos "libpcap"
  uses_from_macos "python@2" # See https://github.com/zeek/zeek/issues/706

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-caf=#{Formula["caf"].opt_prefix}",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--disable-broker-tests",
                          "--localstatedir=#{var}",
                          "--conf-files-dir=#{etc}"
    system "make", "install"
  end

  test do
    system "#{bin}/zeek", "--version"
  end
end
