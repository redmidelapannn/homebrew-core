class Ipsumdump < Formula
  desc "Summarizes TCP/IP dump files into a self-describing ASCII format"
  homepage "http://www.read.seas.harvard.edu/~kohler/ipsumdump/"
  url "http://www.read.seas.harvard.edu/~kohler/ipsumdump/ipsumdump-1.85.tar.gz"
  sha256 "98feca0f323605a022ba0cabcd765a8fcad1b308461360a5ae6c4c293740dc32"
  head "https://github.com/kohler/ipsumdump.git"

  bottle do
    rebuild 1
    sha256 "b482bed5013b37f43eeb77ec948b9b39c464eb0766f063f2c393017b8940900b" => :sierra
    sha256 "b211adefa5ee458e7cc6cbca98dd0684d990fab9cae150e1871edb6a9c9a576c" => :el_capitan
    sha256 "bdc43de06b51e61a7181a83eb733c7e2f5d2f3bc0fb93512938eef427472d591" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ipsumdump", "-c", "-r", test_fixtures("test.pcap").to_s
  end
end
