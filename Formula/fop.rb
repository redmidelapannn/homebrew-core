class Fop < Formula
  desc "XSL-FO print formatter for making PDF or PS documents"
  homepage "https://xmlgraphics.apache.org/fop/index.html"
  url "https://www.apache.org/dyn/closer.cgi?path=/xmlgraphics/fop/binaries/fop-2.1-bin.tar.gz"
  sha256 "a93b59aa4d0b6d573c9090d8f21dee6c7d0c449a4bd2d48a1723e233dfb423ea"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "e9a977cc98e7d3ef4256707e7fa9eb391b4777caeb0eaccf6759e6311e3aae2c" => :el_capitan
    sha256 "3a218818f133fc1d219f741cb239659c9f8da7aa82acb0999e726c10a27c51aa" => :yosemite
    sha256 "b499c48aad9e316ea21fb1907a7ccf902176ff5638716c7325d213dd6a7eaa13" => :mavericks
  end

  depends_on :java => "1.6+"

  resource "hyph" do
    url "https://downloads.sourceforge.net/project/offo/offo-hyphenation-utf8/0.1/offo-hyphenation-fop-stable-utf8.zip"
    sha256 "0b4e074635605b47a7b82892d68e90b6ba90fd2af83142d05878d75762510128"
  end

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"fop"
    resource("hyph").stage do
      (libexec/"build").install "fop-hyph.jar"
    end
  end

  test do
    (testpath/"test.xml").write "<name>Homebrew</name>"
    (testpath/"test.xsl").write <<-EOS.undent
      <?xml version="1.0" encoding="utf-8"?>
      <xsl:stylesheet version="1.0"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:fo="http://www.w3.org/1999/XSL/Format">
        <xsl:output method="xml" indent="yes"/>
        <xsl:template match="/">
          <fo:root>
            <fo:layout-master-set>
              <fo:simple-page-master master-name="A4-portrait"
                    page-height="29.7cm" page-width="21.0cm" margin="2cm">
                <fo:region-body/>
              </fo:simple-page-master>
            </fo:layout-master-set>
            <fo:page-sequence master-reference="A4-portrait">
              <fo:flow flow-name="xsl-region-body">
                <fo:block>
                  Hello, <xsl:value-of select="name"/>!
                </fo:block>
              </fo:flow>
            </fo:page-sequence>
          </fo:root>
        </xsl:template>
      </xsl:stylesheet>
    EOS
    system bin/"fop", "-xml", "test.xml", "-xsl", "test.xsl", "-pdf", "test.pdf"
    File.exist? testpath/"test.pdf"
  end
end
