class Netperf < Formula
  desc "Benchmarks performance of many different types of networking"
  homepage "https://hewlettpackard.github.io/netperf/"
  url "https://github.com/HewlettPackard/netperf/archive/netperf-2.7.0.tar.gz"
  sha256 "4569bafa4cca3d548eb96a486755af40bd9ceb6ab7c6abd81cc6aa4875007c4e"
  head "https://github.com/HewlettPackard/netperf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1445f286d21e7de5f75cc905a85fb58020af00be7c630aaebbb77e1f7deb255b" => :sierra
    sha256 "9b3e6bfce1057cc7a3454288ae45684ef1c9805b23f2c4f52afa0fa6376e8057" => :el_capitan
    sha256 "12102c72722ff5a7a337414a41b6f3bc7fa67fd4dc32aadd84693c22907c99e8" => :yosemite
    sha256 "026fe8418ea6be50576850a9b3cde6a5a71a7d93924a1eb6b77cba88675b2a89" => :mavericks
    sha256 "4e0aa192670d1de341e77e0bd3af4b2cccc6a5b12a734e922e92c7b7d50f281d" => :mountain_lion
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
