class Docbook2x < Formula
  desc "Convert DocBook to UNIX manpages and GNU TeXinfo"
  homepage "https://docbook2x.sourceforge.io/"
  url "https://downloads.sourceforge.net/docbook2x/docbook2X-0.8.8.tar.gz"
  sha256 "4077757d367a9d1b1427e8d5dfc3c49d993e90deabc6df23d05cfe9cd2fcdc45"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5838de44cbc8b6eaf69d51d6b726b6f8bbba2c1fd4158d2f834af4373428084b" => :sierra
    sha256 "a34a340f3a4ec53f97f7dd5f1573303992c89fece9a325e55880b9513a27e763" => :el_capitan
    sha256 "a23df612db8bbe40b781c92e26ad141f8211fb0bb11b495cdfb7348a40acf450" => :yosemite
  end

  depends_on "docbook"

  def install
    inreplace "perl/db2x_xsltproc.pl", "http://docbook2x.sf.net/latest/xslt", "#{share}/docbook2X/xslt"
    inreplace "configure", "${prefix}", prefix
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    (testpath/"brew.1.xml").write <<-EOS.undent
      <?xml version="1.0" encoding="ISO-8859-1"?>
      <!DOCTYPE refentry PUBLIC "-//OASIS//DTD DocBook XML V4.4//EN"
                         "http://www.oasis-open.org/docbook/xml/4.4/docbookx.dtd">
      <refentry id='brew1'>
      <refmeta>
        <refentrytitle>brew</refentrytitle>
        <manvolnum>1</manvolnum>
      </refmeta>
      <refnamediv>
        <refname>brew</refname>
        <refpurpose>The missing package manager for macOS</refpurpose>
      </refnamediv>
      </refentry>
    EOS
    system bin/"docbook2man", testpath/"brew.1.xml"
    assert_predicate testpath/"brew.1", :exist?, "Failed to create man page!"
  end
end
