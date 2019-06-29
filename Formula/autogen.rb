class Autogen < Formula
  desc "Automated text file generator"
  homepage "https://autogen.sourceforge.io"
  url "https://ftp.gnu.org/gnu/autogen/rel5.18.16/autogen-5.18.16.tar.xz"
  mirror "https://ftpmirror.gnu.org/autogen/rel5.18.16/autogen-5.18.16.tar.xz"
  sha256 "f8a13466b48faa3ba99fe17a069e71c9ab006d9b1cfabe699f8c60a47d5bb49a"

  bottle do
    rebuild 1
    sha256 "4b929552169011f3213a2542fb9fa38a061d873c0a5e14aed0befbd1e7d430f2" => :mojave
    sha256 "bc9a4845ee36d1a1e4354be652634ae6c513314701eab052792fdd729a50c1e9" => :high_sierra
    sha256 "ca9e5409e6fc374b10f6a4e128093786f5a631b49fae7f394d2e714f0ad4120f" => :sierra
  end

  depends_on "coreutils" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"
  uses_from_macos "libxml2"

  def install
    # Uses GNU-specific mktemp syntax: https://sourceforge.net/p/autogen/bugs/189/
    inreplace %w[agen5/mk-stamps.sh build-aux/run-ag.sh config/mk-shdefs.in], "mktemp", "gmktemp"
    # Upstream bug regarding "stat" struct: https://sourceforge.net/p/autogen/bugs/187/
    system "./configure", "ac_cv_func_utimensat=no",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    # make and install must be separate steps for this formula
    system "make"
    system "make", "install"
  end

  test do
    system bin/"autogen", "-v"
  end
end
