class DocbookXsl < Formula
  desc "XML vocabulary to create presentation-neutral documents"
  homepage "http://cdn.docbook.org/"
  url "https://github.com/docbook/xslt10-stylesheets/releases/download/release%2F1.79.2/docbook-xsl-1.79.2.tar.gz"
  sha256 "966188d7c05fc76eaca115a55893e643dd01a3486f6368733c9ad974fcee7a26"

  bottle do
    cellar :any_skip_relocation
    sha256 "1785fe61c2f5066bcaab810ec3309e2e480fe8fb6a277aa62a991538e1d001be" => :high_sierra
    sha256 "1785fe61c2f5066bcaab810ec3309e2e480fe8fb6a277aa62a991538e1d001be" => :sierra
    sha256 "1785fe61c2f5066bcaab810ec3309e2e480fe8fb6a277aa62a991538e1d001be" => :el_capitan
  end

  depends_on "docbook"

  resource "ns" do
    url "https://github.com/docbook/xslt10-stylesheets/releases/download/release%2F1.79.2/docbook-xsl-nons-1.79.2.tar.gz"
    sha256 "f89425b44e48aad24319a2f0d38e0cb6059fdc7dbaf31787c8346c748175ca8e"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    doc_files = %w[AUTHORS BUGS COPYING NEWS README RELEASE-NOTES.txt TODO VERSION VERSION.xsl]
    xsl_files = %w[assembly catalog.xml common docsrc eclipse epub epub3 extensions
                   fo highlighting html htmlhelp images javahelp lib manpages
                   params profiling roundtrip slides template tests tools webhelp
                   website xhtml xhtml-1_1 xhtml5]
    (prefix/"docbook-xsl").install xsl_files + doc_files
    resource("ns").stage do
      (prefix/"docbook-xsl-ns").install xsl_files + doc_files
    end

    bin.write_exec_script "#{prefix}/docbook-xsl/epub/bin/dbtoepub"
  end

  def post_install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    [prefix/"docbook-xsl/catalog.xml", prefix/"docbook-xsl-ns/catalog.xml"].each do |catalog|
      system "xmlcatalog", "--noout", "--del", "file://#{catalog}", "#{etc}/xml/catalog"
      system "xmlcatalog", "--noout", "--add", "nextCatalog", "", "file://#{catalog}", "#{etc}/xml/catalog"
    end
  end

  test do
    system "xmlcatalog", "#{etc}/xml/catalog", "http://cdn.docbook.org/release/xsl/1.79.2/"
  end
end
