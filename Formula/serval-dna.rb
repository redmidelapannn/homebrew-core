class ServalDna < Formula
  desc "Serval is an open-source, delay-tolerant networking system."
  homepage "http://www.servalproject.org"
  url "https://github.com/servalproject/serval-dna/archive/c78ee668d5a08ca4f528a4260de384aaa2a06fed.tar.gz"
  version "0.93"
  sha256 "314b50bf0f45c6a4ff118a3f8b0d305e15c234bdb773bf505152689e9428e0b3"
  head "https://github.com/servalproject/serval-dna.git", :branch => "development"

  bottle do
    cellar :any_skip_relocation
    sha256 "312602c4bdea9b55efb83715164ac36be66ee1cee25b94c1e5a94e4f279cc0e1" => :el_capitan
    sha256 "b8370043eb60ff8844e035394bcd5f546873bdbab1050a3a4e75c368575478ea" => :yosemite
    sha256 "125f1674c226a78af47018da53846cf31e40779e87c89c7f291402f0049e95e6" => :mavericks
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  def install
    system "autoreconf", "-f", "-i", "-I", "m4"
    system "./configure"
    File.write("#{buildpath}/VERSION.txt", "#{version}\n")
    system "make", "servald"
    bin.install "servald"
  end

  test do
    system "#{bin}/servald", "version"
  end
end
