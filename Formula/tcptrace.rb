class Tcptrace < Formula
  desc "Analyze tcpdump output"
  homepage "http://www.tcptrace.org/" # site is currently offline
  url "https://www.mirrorservice.org/sites/distfiles.macports.org/tcptrace/tcptrace-6.6.7.tar.gz"
  mirror "https://distfiles.macports.org/tcptrace/tcptrace-6.6.7.tar.gz"
  sha256 "63380a4051933ca08979476a9dfc6f959308bc9f60d45255202e388eb56910bd"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5d50d118784f42da385f32dc25f99fc2e6ab5de8e5d9ba040560be101361689f" => :sierra
    sha256 "6edc33ab75ab8ebb49c4312c9b87f3e275fb894d032d246eab86d9754fbd5d18" => :el_capitan
    sha256 "997d97decc33c951bc72de74e6d53bad0b819d29b73114ca0504eea0557e6eba" => :yosemite
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "tcptrace"

    # don't install with owner/group
    inreplace "Makefile", "-o bin -g bin", ""
    system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man}"
  end

  test do
    touch "dump"
    assert_match(/0 packets seen, 0 TCP packets/,
      shell_output("#{bin}/tcptrace dump"))
  end
end
