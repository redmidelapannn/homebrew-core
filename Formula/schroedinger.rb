class Schroedinger < Formula
  desc "High-speed implementation of the Dirac codec"
  homepage "https://launchpad.net/schroedinger"
  url "https://launchpad.net/schroedinger/trunk/1.0.11/+download/schroedinger-1.0.11.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/s/schroedinger/schroedinger_1.0.11.orig.tar.gz"
  sha256 "1e572a0735b92aca5746c4528f9bebd35aa0ccf8619b22fa2756137a8cc9f912"

  bottle do
    cellar :any
    rebuild 2
    sha256 "759305e93b1a978825e7f9309bfe10c651377c8112117d014021d5f53ae8cc9a" => :high_sierra
    sha256 "ed093f438e5d19eb30464bb8a78cbdcbad3afed3bf1a467ca653a40acf2d7814" => :sierra
    sha256 "4f846c0262abf97f56030452ca93299be1fcfcbe65e9bfc16322c2546f842506" => :el_capitan
  end

  head do
    url "lp:schroedinger", :using => :bzr

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
