class MidnightCommander < Formula
  desc "Terminal-based visual file manager"
  homepage "https://www.midnight-commander.org/"
  url "https://www.midnight-commander.org/downloads/mc-4.8.19.tar.xz"
  mirror "https://fossies.org/linux/misc/mc-4.8.19.tar.xz"
  sha256 "eb9e56bbb5b2893601d100d0e0293983049b302c5ab61bfb544ad0ee2cc1f2df"
  head "https://github.com/MidnightCommander/mc.git"

  bottle do
    rebuild 1
    sha256 "d2ed6cd4c3d99410c74ea0c1dc10fb4f20f0615bd1715e20f9db0d97511c7bf4" => :sierra
    sha256 "6bf4b8ee03126b330af636b994be6d76a4669abf179bf5bad2528ac6f8667c2b" => :el_capitan
    sha256 "48144cfc1e0a2c2297c66b0b940b14cf7a620cc304b124820e50006d9a32eb4a" => :yosemite
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

    # Fix compilation bug on macOS 10.13 by pretending we don't have utimensat()
    # https://github.com/MidnightCommander/mc/pull/130
    ENV["ac_cv_func_utimensat"] = "no" if MacOS.version >= :high_sierra

    args << "--disable-nls" if build.without? "nls"

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "GNU Midnight Commander", shell_output("#{bin}/mc --version")
  end
end
