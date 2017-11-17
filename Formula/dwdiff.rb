class Dwdiff < Formula
  desc "Diff that operates at the word level"
  homepage "https://os.ghalkes.nl/dwdiff.html"
  url "https://os.ghalkes.nl/dist/dwdiff-2.1.1.tar.bz2"
  sha256 "9745860faad6cb58744c7c45d16c0c7e222896c80d0cd7208dd36126d1a98c8b"

  bottle do
    rebuild 1
    sha256 "6d5a3ce9fec19b4994c3155b664e106298916ecc209be21885d2c8cb04ffc580" => :high_sierra
    sha256 "043c3bbba2dc3e345cf500bc553306c5aa2bebfda76040781729b2f37ead42da" => :sierra
    sha256 "58c5afdf3bd6308f99ef8f25a7232cc383bfb407c6e2f96e0bbfd6d7ddeac044" => :el_capitan
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
