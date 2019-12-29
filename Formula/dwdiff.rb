class Dwdiff < Formula
  desc "Diff that operates at the word level"
  homepage "https://os.ghalkes.nl/dwdiff.html"
  url "https://os.ghalkes.nl/dist/dwdiff-2.1.2.tar.bz2"
  sha256 "3201fd459164ebbb538a0b21ce17d955f2fa3babe37367b2e92f7f912cfac692"
  revision 3

  bottle do
    sha256 "f80b15c5e3e5366333b32c95a97f03fe30230a68b8cdc4480efb0b4970853ab3" => :catalina
    sha256 "71b854ea3ff912a69a9e8aaf10e64120bcd5c8f6812c9c2ec9df9780413fe1c7" => :mojave
    sha256 "6b661fe5118cc7dba2a843d513c39b4a94559b97ac44f4c56d157d42422c3c77" => :high_sierra
  end

  depends_on "pkg-config" => :build
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
