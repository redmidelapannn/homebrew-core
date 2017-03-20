class Schroedinger < Formula
  desc "High-speed implementation of the Dirac codec"
  homepage "https://launchpad.net/schroedinger"
  url "https://launchpad.net/schroedinger/trunk/1.0.11/+download/schroedinger-1.0.11.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/s/schroedinger/schroedinger_1.0.11.orig.tar.gz"
  sha256 "1e572a0735b92aca5746c4528f9bebd35aa0ccf8619b22fa2756137a8cc9f912"

  bottle do
    cellar :any
    rebuild 2
    sha256 "ce6ba4bce2d364d99c75438e2b68c52249a991b4bcf904e1d3fdc61374c4f5f2" => :sierra
    sha256 "11cf48cd14b0866657742466717338efc84a79db879a75207492e25e0072d8f7" => :el_capitan
    sha256 "bf8f628d74ddd0b5f6783bc054bc4c814899fa1f531bf23952f063a1a7cee8ff" => :yosemite
  end

  head do
    url "git://diracvideo.org/git/schroedinger.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "orc"

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # The test suite is known not to build against Orc >0.4.16 in Schroedinger 1.0.11.
    # A fix is in upstream, so test when pulling 1.0.12 if this is still needed. See:
    # https://www.mail-archive.com/schrodinger-devel@lists.sourceforge.net/msg00415.html
    inreplace "Makefile" do |s|
      s.change_make_var! "SUBDIRS", "schroedinger doc tools"
      s.change_make_var! "DIST_SUBDIRS", "schroedinger doc tools"
    end

    system "make", "install"
  end
end
