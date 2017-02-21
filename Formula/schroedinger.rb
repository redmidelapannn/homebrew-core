class Schroedinger < Formula
  desc "High-speed implementation of the Dirac codec"
  homepage "https://launchpad.net/schroedinger"
  url "http://diracvideo.org/download/schroedinger/schroedinger-1.0.11.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/s/schroedinger/schroedinger_1.0.11.orig.tar.gz"
  sha256 "1e572a0735b92aca5746c4528f9bebd35aa0ccf8619b22fa2756137a8cc9f912"

  bottle do
    cellar :any
    rebuild 2
    sha256 "6eee203e5eb11133483b306efa4d54c5c5923a1871998c13dfcd019b5e8d6a53" => :sierra
    sha256 "5ccf6758e64f2180302998fd47d7653fb54cb5223077019bf0fcd1a23eb64193" => :el_capitan
    sha256 "7dcece63f3857c908df7088ab43b5b7c97ea43881af6dd85678231c474acfdf0" => :yosemite
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
