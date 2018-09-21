class Bro < Formula
  desc "Network security monitor"
  homepage "https://www.bro.org"
  url "https://www.bro.org/downloads/bro-2.5.5.tar.gz"
  sha256 "18f2aeb10b4d935d85c115a1e4a93464b9750be19b34997cf6196b29118e73cf"
  head "https://github.com/bro/bro.git"

  bottle do
    rebuild 1
    sha256 "d4e72a7c32205339d977f5e8e018de15d4f08d684e495d0c260578dc24ef7dc2" => :high_sierra
    sha256 "244fd02ca189108b54d6ab93b9ac52bdf73ccd4acc55413da38ce78a76e766cd" => :sierra
    sha256 "68ee7e115f64cb63715b83a41534842ad124123927ad2052e567a691a21e64ab" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "geoip"
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}",
                          "--localstatedir=#{var}",
                          "--conf-files-dir=#{etc}"
    system "make", "install"
  end

  test do
    system "#{bin}/bro", "--version"
  end
end
