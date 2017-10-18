class Udptunnel < Formula
  desc "Tunnel UDP packets over a TCP connection"
  homepage "https://web.archive.org/web/20161224191851/www.cs.columbia.edu/~lennox/udptunnel/"
  url "https://web.archive.org/web/20161224191851/www.cs.columbia.edu/~lennox/udptunnel/udptunnel-1.1.tar.gz"
  mirror "https://ftp.nsysu.edu.tw/FreeBSD/ports/local-distfiles/leeym/udptunnel-1.1.tar.gz"
  sha256 "45c0e12045735bc55734076ebbdc7622c746d1fe4e6f7267fa122e2421754670"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "cba4454cd9901aa29a551f7b1c6e08fceefd0f31230d32fa6dbee4fee531e0c5" => :high_sierra
    sha256 "8611426855b684ddb64bf027532001ec2379ac88c09c0b2e4e15d4c08d95b947" => :sierra
    sha256 "5f0049ab16f67fc5d24a945414cfc46d0bad37b8dffba41deaa0acdc768fa0a4" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    doc.install "udptunnel.html"
  end

  test do
    system "#{bin}/udptunnel -h; true"
  end
end
