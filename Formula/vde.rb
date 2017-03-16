class Vde < Formula
  desc "Ethernet compliant virtual network"
  homepage "https://vde.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/vde/vde2/2.3.2/vde2-2.3.2.tar.gz"
  sha256 "22df546a63dac88320d35d61b7833bbbcbef13529ad009c7ce3c5cb32250af93"

  bottle do
    rebuild 1
    sha256 "d2279e07179d4cb33a647e161729400ad48bdad526cbd4f34af1e46cf874056c" => :sierra
    sha256 "41389ec662d8ed007ac543b82bd6e33b1d46eb174431d237391acd21765d58d3" => :el_capitan
    sha256 "0e774f1cf459b0ac61f2b031f3d03da030d3482a323dd654df86edaae250173b" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    # 2.3.1 built in parallel but 2.3.2 does not. See:
    # https://sourceforge.net/p/vde/bugs/54/
    ENV.deparallelize
    system "make", "install"
  end
end
