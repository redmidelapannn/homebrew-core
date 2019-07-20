class Sgrep < Formula
  desc "Search SGML, XML, and HTML"
  homepage "https://www.cs.helsinki.fi/u/jjaakkol/sgrep.html"
  url "https://www.cs.helsinki.fi/pub/Software/Local/Sgrep/sgrep-1.94a.tar.gz"
  mirror "https://fossies.org/linux/misc/old/sgrep-1.94a.tar.gz"
  sha256 "d5b16478e3ab44735e24283d2d895d2c9c80139c95228df3bdb2ac446395faf9"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bd2337e6ad3598e76710069a6e2a4bdd8c29ed9a8c033c8961b50d9e56087d6b" => :mojave
    sha256 "bd9f2dd8648501d72d74070e3a03eedda7e5ef28694eb0bbb9624c6f51d828b4" => :high_sierra
    sha256 "43378d38715d11a6b66694a0813ad3ddc2086f5ec823283e04ecb418dc678daa" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--datadir=#{pkgshare}"
    system "make", "install"
  end

  test do
    input = test_fixtures("test.eps")
    assert_equal "2", shell_output("#{bin}/sgrep -c '\"mark\"' #{input}").strip
  end
end
