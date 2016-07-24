class Memcacheq < Formula
  desc "Queue service for memcache"
  homepage "http://memcachedb.org/memcacheq"
  url "https://memcacheq.googlecode.com/files/memcacheq-0.2.0.tar.gz"
  sha256 "b314c46e1fb80d33d185742afe3b9a4fadee5575155cb1a63292ac2f28393046"
  revision 1

  bottle do
    cellar :any
    sha256 "a4c2975ad4cd3e576e646ba3e3d3f4024054f2200070b183a35b586ab4b977c6" => :el_capitan
    sha256 "c1ceab39b005738aa0b90276587c0e8fd049c804e56d1258c22b01e0597b8e3e" => :yosemite
    sha256 "05c9ea2e3d4b61a7eea5796d382ed3f49412774c50d46afadacf6d714bfef282" => :mavericks
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
