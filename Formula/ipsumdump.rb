class Ipsumdump < Formula
  desc "Summarizes TCP/IP dump files into a self-describing ASCII format"
  homepage "https://read.seas.harvard.edu/~kohler/ipsumdump/"
  url "https://read.seas.harvard.edu/~kohler/ipsumdump/ipsumdump-1.86.tar.gz"
  sha256 "e114cd01b04238b42cd1d0dc6cfb8086a6b0a50672a866f3d0d1888d565e3b9c"
  head "https://github.com/kohler/ipsumdump.git"

  bottle do
    rebuild 1
    sha256 "d3821fa2c9d5382b2e4293d88934aba5a0ec26ded1d4e402709731cfafbc92b2" => :mojave
    sha256 "f5299e038d7ef71726f83a3cceee74df1b16745b95b5a8275de5e577940d3a59" => :high_sierra
    sha256 "fccbd1d91108abceadf1e26ab3812c9a6fecca9fab87abd0bb7f0b452c7c51d4" => :sierra
    sha256 "01c3ebbf6cb922b4070e4fcb5d45e5d503098258559f48d009c8569ecb14b033" => :el_capitan
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
