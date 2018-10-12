class AutoconfAT213 < Formula
  desc "Automatic configure script builder"
  homepage "https://www.gnu.org/software/autoconf/"
  url "https://ftp.gnu.org/gnu/autoconf/autoconf-2.13.tar.gz"
  mirror "https://ftpmirror.gnu.org/autoconf/autoconf-2.13.tar.gz"
  sha256 "f0611136bee505811e9ca11ca7ac188ef5323a8e2ef19cffd3edb3cf08fd791e"
  revision 1

  bottle do
    sha256 "16ec764548d026a8d68d6b8fe8f68b0f765ab201125ea1faf05063103666ac2a" => :mojave
    sha256 "9dc92e1357531771f346175bb2aa2bb2319c44e52952e556872d51d6f6a271b4" => :high_sierra
    sha256 "9dc92e1357531771f346175bb2aa2bb2319c44e52952e556872d51d6f6a271b4" => :sierra
  end

  keg_only :versioned_formula

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--infodir=#{pkgshare}/info",
                          "--datadir=#{pkgshare}"
    system "make", "install"
  end

  test do
    assert_match "Usage: autoconf", shell_output("#{bin}/autoconf --help 2>&1")
  end
end
