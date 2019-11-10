class Zeek < Formula
  desc "Network security monitor"
  homepage "https://www.zeek.org"
  url "https://www.zeek.org/downloads/zeek-3.0.0.tar.gz"
  sha256 "b552940a14132bcbbd9afdf6476ec615b5a44a6d15f78b2cdc15860fa02bff9a"
  head "https://github.com/zeek/zeek.git"

  bottle do
    sha256 "a94c7b3051fc0396b61ea3a9454b22b84963a7d965fba763bb4f6094ebda0ef1" => :catalina
    sha256 "f090a1e14285e41be709d3a0a0bed7582c99c82512e452ec634fdb193166d390" => :mojave
    sha256 "975405028770df5602f86acc575dd9fc9a329d664f45e1eebdd782d5a154f506" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "geoip"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--localstatedir=#{var}",
                          "--conf-files-dir=#{etc}"
    system "make", "install"
  end

  test do
    system "#{bin}/zeek", "--version"
  end
end
