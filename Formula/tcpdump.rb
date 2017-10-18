class Tcpdump < Formula
  desc "Command-line packet analyzer"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/tcpdump-4.9.2.tar.gz"
  sha256 "798b3536a29832ce0cbb07fafb1ce5097c95e308a6f592d14052e1ef1505fe79"
  head "https://github.com/the-tcpdump-group/tcpdump.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2f4b72f378b24d067f54b87c58dad06fa275dcd3f0d594c2bb1f0c020013ac72" => :high_sierra
    sha256 "763720a7ebdd853bb5ae302153576fc0211e5ed6b49755236298b075aa2eca7a" => :sierra
    sha256 "02ac1bf69b9d6ea0bf66d55566702ff146ed8989484fff2a6494f033b220be13" => :el_capitan
  end

  depends_on "openssl"
  depends_on "libpcap" => :optional

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-ipv6",
                          "--disable-smb",
                          "--disable-universal"
    system "make", "install"
  end

  test do
    system sbin/"tcpdump", "--help"
  end
end
