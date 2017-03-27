class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "https://www.midnight-commander.org/downloads/mc-4.8.19.tar.xz"
  mirror "https://fossies.org/linux/misc/mc-4.8.19.tar.xz"
  sha256 "eb9e56bbb5b2893601d100d0e0293983049b302c5ab61bfb544ad0ee2cc1f2df"
  head "https://github.com/MidnightCommander/mc.git"

  bottle do
    rebuild 1
    sha256 "eb35d35659d195da21770d3d480230a160cc4abc2eea994620d679d29293d2e8" => :sierra
    sha256 "a7332e24b933a5d236eb3dbdc80e128bf23ed6149715cecd5acd128e9afdc3ac" => :el_capitan
    sha256 "5eb9925ee54589742d24145e1ee7c28f04788e043830ce9370b0f25042ed841b" => :yosemite
  end

  option "without-nls", "Build without Native Language Support"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl"
  depends_on "s-lang"
  depends_on "libssh2"

  conflicts_with "minio-mc", :because => "Both install a `mc` binary"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --without-x
      --with-screen=slang
      --enable-vfs-sftp
    ]

    args << "--disable-nls" if build.without? "nls"

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "GNU Midnight Commander", shell_output("#{bin}/mc --version")
  end
end
