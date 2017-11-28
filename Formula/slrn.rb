class Slrn < Formula
  desc "Powerful console-based newsreader"
  homepage "https://slrn.sourceforge.io/"
  url "https://jedsoft.org/releases/slrn/slrn-1.0.3a.tar.bz2"
  sha256 "3ba8a4d549201640f2b82d53fb1bec1250f908052a7983f0061c983c634c2dac"

  head "git://git.jedsoft.org/git/slrn.git"

  bottle do
    rebuild 1
    sha256 "9f56b0a8ceaf5da64176a4f0053dcd6e746aa9958540df4ddaf96820bfbeed65" => :high_sierra
    sha256 "b512bf5c45323b8de1eebbc2892bcc45cd3f085ff5a1e73d7f5ce1e68ed7a95f" => :sierra
    sha256 "fdd3797fcd93a36afd0ac02d24efee2f3aa07abd0f45f3347cf4bb385cbf3936" => :el_capitan
  end

  depends_on "s-lang"
  depends_on "openssl"

  def install
    bin.mkpath
    man1.mkpath
    mkdir_p "#{var}/spool/news/slrnpull"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}",
                          "--with-slrnpull=#{var}/spool/news/slrnpull",
                          "--with-slang=#{HOMEBREW_PREFIX}"
    system "make", "all", "slrnpull"

    ENV.deparallelize
    system "make", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    assert_match version.to_s, shell_output("#{bin}/slrn --show-config")
  end
end
