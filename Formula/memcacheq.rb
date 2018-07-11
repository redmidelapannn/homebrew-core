class Memcacheq < Formula
  desc "Queue service for memcache"
  homepage "https://memcachedb.org/memcacheq/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/memcacheq/memcacheq-0.2.0.tar.gz"
  sha256 "b314c46e1fb80d33d185742afe3b9a4fadee5575155cb1a63292ac2f28393046"
  revision 3

  bottle do
    cellar :any
    rebuild 1
    sha256 "95dc4d4dd2ad788f3c329818d752b470f93a312bc68366f8a7cc372459f62276" => :high_sierra
    sha256 "912ad516d09344a4a8bcfd61fa747fcd97100406bbd872bbd8c4c06e8f3b67ea" => :sierra
    sha256 "36d7ee96d7a9ba7c749460db4b16cd41bd4aa155d442cef33a352c48a2fd0689" => :el_capitan
  end

  depends_on "berkeley-db"
  depends_on "libevent"

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-threads"
    system "make", "install"
  end
end
