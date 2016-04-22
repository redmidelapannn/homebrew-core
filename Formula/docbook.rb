class Docbook < Formula
  desc "Standard SGML representation system for technical documents"
  homepage "http://docbook.sourceforge.net/"
  url "http://www.docbook.org/xml/5.0/docbook-5.0.zip"
  sha256 "3dcd65e1f5d9c0c891b3be204fa2bb418ce485d32310e1ca052e81d36623208e"

  bottle do
    cellar :any_skip_relocation
    revision 4
    sha256 "1d483cd688e401cb1ea5db17b026ec227d51cfb328923092a26333630803d246" => :el_capitan
    sha256 "be36c50af34fe7300cc9e938f75daf6dd06ed15a8ae9a6317dfae1dfad04fc5c" => :yosemite
    sha256 "18d11de801f908a5078dccace0b5d52e59bb67a0e123e6fa1f1b35dafd670df9" => :mavericks
  end

  resource "xml412" do
    url "http://www.docbook.org/xml/4.1.2/docbkx412.zip"
    sha256 "30f0644064e0ea71751438251940b1431f46acada814a062870f486c772e7772"
    version "4.1.2"
  end

  resource "xml42" do
    url "http://www.docbook.org/xml/4.2/docbook-xml-4.2.zip"
    sha256 "acc4601e4f97a196076b7e64b368d9248b07c7abf26b34a02cca40eeebe60fa2"
  end

  resource "xml43" do
    url "http://www.docbook.org/xml/4.3/docbook-xml-4.3.zip"
    sha256 "23068a94ea6fd484b004c5a73ec36a66aa47ea8f0d6b62cc1695931f5c143464"
  end

  resource "xml44" do
    url "http://www.docbook.org/xml/4.4/docbook-xml-4.4.zip"
    sha256 "02f159eb88c4254d95e831c51c144b1863b216d909b5ff45743a1ce6f5273090"
  end

  resource "xml45" do
    url "http://www.docbook.org/xml/4.5/docbook-xml-4.5.zip"
    sha256 "4e4e037a2b83c98c6c94818390d4bdd3f6e10f6ec62dd79188594e26190dc7b4"
  end

  resource "xml50" do
    url "http://www.docbook.org/xml/5.0/docbook-5.0.zip"
    sha256 "3dcd65e1f5d9c0c891b3be204fa2bb418ce485d32310e1ca052e81d36623208e"
  end

  def install
    (etc/"xml").mkpath

    %w[42 412 43 44 45 50].each do |version|
      # Ruby 1.8.7 workaround: without the second argument, r will be an Array
      resource("xml#{version}").stage do |r, _|
        if version == "412"
          cp prefix/"docbook/xml/4.2/catalog.xml", "catalog.xml"

          inreplace "catalog.xml" do |s|
            s.gsub! "V4.2 ..", "V4.1.2 "
            s.gsub! "4.2", "4.1.2"
          end
        end

        rm_rf "docs"
        (prefix/"docbook/xml"/r.version).install Dir["*"]
      end
    end
  end

  def post_install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    # only create catalog file if it doesn't exist already to avoid content added
    # by other formulae to be removed
    unless File.file?("#{etc}/xml/catalog")
      system "xmlcatalog", "--noout", "--create", "#{etc}/xml/catalog"
    end

    %w[4.2 4.1.2 4.3 4.4 4.5 5.0].each do |version|
      catalog = prefix/"docbook/xml/#{version}/catalog.xml"

      system "xmlcatalog", "--noout", "--del",
             "file://#{catalog}", "#{etc}/xml/catalog"
      system "xmlcatalog", "--noout", "--add", "nextCatalog",
             "", "file://#{catalog}", "#{etc}/xml/catalog"
    end
  end

  def caveats; <<-EOS.undent
    To use the DocBook package in your XML toolchain,
    you need to add the following to your ~/.bashrc:

    export XML_CATALOG_FILES="#{etc}/xml/catalog"
    EOS
  end
end
