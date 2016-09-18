class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/v1.4.0.tar.gz"
  sha256 "0be686901773c2648b504137b9bae5e3c7c1373f07ae3f943753cabe3e1b3c51"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "baea5665e9cb4e775ccf615486be1c632b29a02653b1e52182ce8d798ee61552" => :sierra
    sha256 "2d43fda58ecfae1dc3781331fea49842bd3a4448a3ba4e293c3c798dbc1dc480" => :el_capitan
    sha256 "74ba38790d5263e34c43f8f8c970e610d2a0d514cb3b9ac5a06072e18f00cfce" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    pipe_output("#{bin}/sngrep -I #{test_fixtures("test.pcap")}", "Q\n", 0)
  end
end
