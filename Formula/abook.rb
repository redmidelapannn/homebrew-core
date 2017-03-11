class Abook < Formula
  desc "Address book with mutt support"
  homepage "https://abook.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/abook/abook/0.5.6/abook-0.5.6.tar.gz"
  sha256 "0646f6311a94ad3341812a4de12a5a940a7a44d5cb6e9da5b0930aae9f44756e"
  revision 1

  head "https://git.code.sf.net/p/abook/git.git"

  bottle do
    rebuild 1
    sha256 "30d384e8633537266f4d6dbc43afdd8d49f8f8086bb5a37a8a9d207f9ce9b873" => :sierra
    sha256 "85b0626c11d9ad82a143bb7ad32bb81b5ad297ac4581447493a98f82d71125c1" => :el_capitan
    sha256 "d39417de4ec50301e64dc209f69391439afb2c1976d6bdce6df157d5f4cf636a" => :yosemite
  end

  devel do
    url "https://abook.sourceforge.io/devel/abook-0.6.0pre2.tar.gz"
    sha256 "59d444504109dd96816e003b3023175981ae179af479349c34fa70bc12f6d385"
    version "0.6.0pre2"

    # Remove `inline` from function implementation for clang compatibility
    patch :DATA
  end

  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/abook", "--formats"
  end
end

__END__
diff --git a/database.c b/database.c
index 7c47ab6..53bdb9f 100644
--- a/database.c
+++ b/database.c
@@ -762,7 +762,7 @@ item_duplicate(list_item dest, list_item src)
  */
 
 /* quick lookup by "standard" field number */
-inline int
+int
 field_id(int i)
 {
 	assert((i >= 0) && (i < ITEM_FIELDS));
