class Dwdiff < Formula
  desc "Diff that operates at the word level"
  homepage "http://os.ghalkes.nl/dwdiff.html"
  url "http://os.ghalkes.nl/dist/dwdiff-2.1.0.tar.bz2"
  sha256 "45308f2f07c08c75c6ebd1eae3e3dcf7f836e5af1467cefc1b4829777c07743a"
  revision 5

  bottle do
    sha256 "b898275fd68d40dbbee4e58cb689aca51df6d7d973d5938522f10f1163b22310" => :sierra
    sha256 "95d1e79aeaafa63b35029f88c2ee1be904344a09286301e4055113e35fd4999e" => :el_capitan
    sha256 "b58d2741b5970e51d01a5847dcff3ba744860786e987813459b26a07cff4e812" => :yosemite
  end

  depends_on "gettext"
  depends_on "icu4c"

  def install
    gettext = Formula["gettext"]
    icu4c = Formula["icu4c"]
    ENV.append "CFLAGS", "-I#{gettext.include} -I#{icu4c.include}"
    ENV.append "LDFLAGS", "-L#{gettext.lib} -L#{icu4c.lib} -lintl"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    # Remove non-English man pages
    (man/"nl").rmtree
    (man/"nl.UTF-8").rmtree
    (share/"locale/nl").rmtree
  end

  test do
    (testpath/"a").write "I like beers"
    (testpath/"b").write "I like formulae"
    diff = shell_output("#{bin}/dwdiff a b", 1)
    assert_equal "I like [-beers-] {+formulae+}", diff
  end
end
