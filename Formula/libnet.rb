class Libnet < Formula
  desc "C library for creating IP packets"
  homepage "https://github.com/sam-github/libnet"
  url "https://github.com/sam-github/libnet/archive/libnet-1.2.tar.gz"
  sha256 "a4fd8022abc9a279fa38abb5409d232d3969cce86cf67e64ea72ca264af71e05"

  bottle do
    cellar :any
    sha256 "efc033859811636cc6c031f4616008de12664c49e8ce16fbd30910f8260bc672" => :mojave
    sha256 "dab3bd81274bbd15f9dac42594284087b3b9def9458dae6bd17ef63c9c8d9937" => :high_sierra
    sha256 "49624a49dca70f525c981abdf630ae63cab60153754fb2750c7a5f604022b1bd" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "libtool" => :build

  def install
    chdir "libnet" do
      system "autoreconf", "-fvi"
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      inreplace "src/libnet_link_bpf.c", "#include <net/bpf.h>", "" # Per MacPorts
      system "make -C doc doc"
      ENV.deparallelize { system "make", "install" }
    end
  end
end
