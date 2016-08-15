class Cvsync < Formula
  desc "Portable CVS repository synchronization utility"
  homepage "http://www.cvsync.org/"
  url "http://www.cvsync.org/dist/cvsync-0.24.19.tar.gz"
  sha256 "75d99fc387612cb47141de4d59cb3ba1d2965157230f10015fbaa3a1c3b27560"

  bottle do
    cellar :any
    revision 1
    sha256 "8b767b7124b2537aa88c17d5a1fc9918813e215e5ea032a120323b62badade16" => :el_capitan
    sha256 "7ff293fab2ecb16bedfb210ec52f9bd36c6590ef64c24c0432dc988bda39a1e4" => :yosemite
    sha256 "8fbe78ccfe812bee92b9fd73de5a53956323fdc7862e9d2c8250c90a950e5da4" => :mavericks
  end

  depends_on "openssl"

  def install
    ENV["PREFIX"] = prefix
    ENV["MANDIR"] = man
    ENV["CVSYNC_DEFAULT_CONFIG"] = etc/"cvsync.conf"
    ENV["CVSYNCD_DEFAULT_CONFIG"] = etc/"cvsyncd.conf"
    ENV["HASH_TYPE"] = "openssl"

    # Makefile from 2005 assumes Darwin doesn't define `socklen_t' and defines
    # it with a CC macro parameter making gcc unhappy about double define.
    inreplace "mk/network.mk",
      /^CFLAGS \+= \-Dsocklen_t=int/, ""

    # Remove owner and group parameters from install.
    inreplace "mk/base.mk",
      /^INSTALL_(.{3})_OPTS\?=.*/, 'INSTALL_\1_OPTS?= -c -m ${\1MODE}'

    # These paths must exist or "make install" fails.
    bin.mkpath
    lib.mkpath
    man1.mkpath

    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cvsync -h 2>&1", 1)
  end
end
