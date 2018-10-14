class XalanC < Formula
  desc "XSLT processor"
  homepage "https://xalan.apache.org/xalan-c/"
  url "https://www.apache.org/dyn/closer.cgi?path=xalan/xalan-c/sources/xalan_c-1.11-src.tar.gz"
  sha256 "4f5e7f75733d72e30a2165f9fdb9371831cf6ff0d1997b1fb64cdd5dc2126a28"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "6eb621257acde2a3ac465630ead843abdc2e6dbb6154a2b036a49a302d8dd070" => :mojave
    sha256 "948308207d8ddc04f378aa08b681fa5c5a01fa452f8dca41632808dc5b279613" => :high_sierra
    sha256 "1a188cc5c5a7656853658dc9dca22afa96846ef2a7c9cadfa0a441cea8a741cd" => :sierra
  end

  depends_on "xerces-c"

  # Fix segfault. See https://issues.apache.org/jira/browse/XALANC-751
  # Build with char16_t casts.  See https://issues.apache.org/jira/browse/XALANC-773
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/master/xalan-c/xerces-char16.patch"
    sha256 "ebd4ded1f6ee002351e082dee1dcd5887809b94c6263bbe4e8e5599f56774ebf"
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/master/xalan-c/locator-system-id.patch"
    sha256 "7c317c6b99cb5fb44da700e954e6b3e8c5eda07bef667f74a42b0099d038d767"
  end

  needs :cxx11

  def install
    ENV.cxx11
    ENV.deparallelize # See https://issues.apache.org/jira/browse/XALANC-696
    ENV["XALANCROOT"] = "#{buildpath}/c"
    ENV["XALAN_LOCALE_SYSTEM"] = "inmem"
    ENV["XALAN_LOCALE"] = "en_US"

    cd "c" do
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{prefix}"
      system "make", "install"

      # Clean up links
      rm Dir["#{lib}/*.dylib.*"]
    end
  end

  test do
    (testpath/"input.xml").write <<~EOS
      <?xml version="1.0"?>
      <Article>
        <Title>An XSLT test-case</Title>
        <Authors>
          <Author>Roger Leigh</Author>
          <Author>Open Microscopy Environment</Author>
        </Authors>
        <Body>This example article is used to verify the functionality
        of Xalan-C++ in applying XSLT transforms to XML documents</Body>
      </Article>
    EOS

    (testpath/"transform.xsl").write <<~EOS
      <?xml version="1.0"?>
      <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:output method="text"/>
        <xsl:template match="/">Article: <xsl:value-of select="/Article/Title"/>
      Authors: <xsl:apply-templates select="/Article/Authors/Author"/>
      </xsl:template>
        <xsl:template match="Author">
      * <xsl:value-of select="." />
        </xsl:template>
      </xsl:stylesheet>
    EOS

    assert_match "Article: An XSLT test-case\nAuthors: \n* Roger Leigh\n* Open Microscopy Environment",
                 shell_output("#{bin}/Xalan #{testpath}/input.xml #{testpath}/transform.xsl")
  end
end
