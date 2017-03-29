class Sgrep < Formula
  desc "Search SGML, XML, and HTML"
  homepage "https://www.cs.helsinki.fi/u/jjaakkol/sgrep.html"
  # curl: (9) Server denied you to change to the given directory
  # ftp://ftp.cs.helsinki.fi/pub/Software/Local/Sgrep/sgrep-1.94a.tar.gz
  url "https://www.mirrorservice.org/sites/distfiles.macports.org/sgrep2/sgrep-1.94a.tar.gz"
  mirror "https://fossies.org/linux/misc/old/sgrep-1.94a.tar.gz"
  sha256 "d5b16478e3ab44735e24283d2d895d2c9c80139c95228df3bdb2ac446395faf9"

  bottle do
    rebuild 1
    sha256 "4ef4b95e85bd237753084e3621e57e1e036ffbe561e4d7c9ee06078f4d8b7ae9" => :sierra
    sha256 "72c8e0f4c5b849e4c4a1e8e6644af9c4f3e13f462f7017a1d9e7e7503f9951eb" => :el_capitan
    sha256 "313d6f4f3f8582c244a866cccdcbf437798e6c4a92b23a6aaae5bd8d53c18724" => :yosemite
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
