# Jigdo is dead upstream. It consists of two components: Jigdo, a GTK+ using GUI,
# which is LONG dead and completely unfunctional, and jigdo-lite, a command-line
# tool that has been on life support and still works. Only build the CLI tool.
class Jigdo < Formula
  desc "Tool to distribute very large files over the internet"
  homepage "http://atterer.org/jigdo/"
  url "http://atterer.org/sites/atterer/files/2009-08/jigdo/jigdo-0.7.3.tar.bz2"
  sha256 "875c069abad67ce67d032a9479228acdb37c8162236c0e768369505f264827f0"
  revision 5

  bottle do
    rebuild 1
    sha256 "cc1aa4ee71cae3e2e3a96109d49952fe6e36669eba28d63751d53e31ab91dcc5" => :mojave
    sha256 "62f6f74ab71e38f53915b8e3f66956a77ff9b8a8b0fe25d827e35ce2d30d1458" => :high_sierra
    sha256 "fe8d624002bb78644ea384585a37d0d40c70a7610c018e1c1605d0341d0a6b6c" => :sierra
    sha256 "099b7e5ff776ed15135f00b1c2931adc3199c99e646d90e80c06ddd9c1cd051c" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "berkeley-db"
  depends_on "wget"

  # Use MacPorts patch for compilation on 10.9; this software is no longer developed.
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e101570/jigdo/patch-src-compat.hh.diff"
    sha256 "a21aa8bcc5a03a6daf47e0ab4e04f16e611e787a7ada7a6a87c8def738585646"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-x11",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "version #{version}", shell_output("#{bin}/jigdo-file -v")
  end
end
