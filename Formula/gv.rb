class Gv < Formula
  desc "View and navigate through PostScript and PDF documents"
  homepage "https://www.gnu.org/s/gv/"
  url "https://ftp.gnu.org/gnu/gv/gv-3.7.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/gv/gv-3.7.4.tar.gz"
  sha256 "2162b3b3a95481d3855b3c4e28f974617eef67824523e56e20b56f12fe201a61"

  bottle do
    rebuild 1
    sha256 "c211739c97392e88d5316173bc86a9382976c9970619b3e85837a953c23203da" => :high_sierra
    sha256 "c5670cc992d3b781588abb6a4144937d44450402a097dc6946cd961b06180de7" => :sierra
    sha256 "af486a6b1fa2257742e2e245931c6ec26cc761b0108ba0a8192c0701c0040958" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "ghostscript" => "with-x11"
  depends_on :x11

  skip_clean "share/gv/safe-gs-workdir"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-SIGCHLD-fallback"
    system "make", "install"
  end

  test do
    system "#{bin}/gv", "--version"
  end
end
