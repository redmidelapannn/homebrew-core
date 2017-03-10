class DejaGnu < Formula
  desc "Framework for testing other programs"
  homepage "https://www.gnu.org/software/dejagnu/"
  url "https://ftpmirror.gnu.org/dejagnu/dejagnu-1.6.tar.gz"
  mirror "https://ftp.gnu.org/gnu/dejagnu/dejagnu-1.6.tar.gz"
  sha256 "00b64a618e2b6b581b16eb9131ee80f721baa2669fa0cdee93c500d1a652d763"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0602e2bb2b7b6908ad3717cf51b376e23a055ef8ac207d7c48bfb19f64f81cdc" => :sierra
    sha256 "0602e2bb2b7b6908ad3717cf51b376e23a055ef8ac207d7c48bfb19f64f81cdc" => :el_capitan
    sha256 "0602e2bb2b7b6908ad3717cf51b376e23a055ef8ac207d7c48bfb19f64f81cdc" => :yosemite
  end

  head do
    url "https://git.savannah.gnu.org/git/dejagnu.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    ENV.deparallelize # Or fails on Mac Pro
    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    # DejaGnu has no compiled code, so go directly to "make check"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/runtest"
  end
end
