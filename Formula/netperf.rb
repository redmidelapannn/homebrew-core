class Netperf < Formula
  desc "Benchmarks performance of many different types of networking"
  homepage "http://netperf.org"
  url "ftp://ftp.netperf.org/netperf/netperf-2.7.0.tar.bz2"
  sha256 "842af17655835c8be7203808c3393e6cb327a8067f3ed1f1053eb78b4e40375a"
  head "http://www.netperf.org/svn/netperf2/trunk", :using => :svn

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4b3c96d8473fd4de2576935ea36df4577dde92ad21cf06970a5d1530133f97f2" => :sierra
    sha256 "08122b9cd65cd1f92fb82571f26645f714764f834d0912f07452ad10ab11f7f5" => :el_capitan
    sha256 "6b47dad57f0fc0a718c7186b001de71732c8c57bb98f3131f35828925156fa35" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/netperf -h | cat"
  end
end
