class Dash < Formula
  desc "POSIX-compliant descendant of NetBSD's ash (the Almquist SHell)"
  # http://gondor.apana.org.au/~herbert/dash/ is offline
  homepage "https://packages.debian.org/source/sid/shells/dash"
  # http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.9.1.tar.gz is offline
  url "https://dl.bintray.com/homebrew/mirror/dash-0.5.9.1.tar.gz"
  mirror "https://ftp.cc.uoc.gr/mirrors/linux/lfs/LFS/svn/d/dash-0.5.9.1.tar.gz"
  sha256 "5ecd5bea72a93ed10eb15a1be9951dd51b52e5da1d4a7ae020efd9826b49e659"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3629f5b8d4c6e1a5e31e08c1c6bf5830867f669b7ee17e255f14765fbafb961d" => :sierra
    sha256 "be2a9212806bb3569a724968163edd00e0f901a582237911753256c417ae8add" => :el_capitan
    sha256 "58f6b84f330eed8d5fd92c216f362136c01be938c806cb9f5f81f0dce2529820" => :yosemite
  end

  head do
    url "https://git.kernel.org/pub/scm/utils/dash/dash.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--with-libedit",
                          "--disable-dependency-tracking",
                          "--enable-fnmatch",
                          "--enable-glob"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/dash", "-c", "echo Hello!"
  end
end
