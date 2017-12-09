class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://github.com/newsboat/newsboat/archive/r2.10.1.tar.gz"
  sha256 "82d5e3e2a6dab845aac0bf72580f46c2756375d49214905a627284e5bc32e327"
  revision 1

  bottle do
    sha256 "0daa1da97ef823dae571186befdd78d543878c4d6d3b2072973e2c33ea3bef8a" => :high_sierra
    sha256 "aaa7d22cfaedb89bd7def5caf8132257ebc9b45089848a15cc20a9c409653cae" => :sierra
    sha256 "6fab33ee3864ce58a8ac4416fc932f9d576ced4471aaeea5d63bd6407d16430b" => :el_capitan
  end

  head do
    url "https://github.com/newsboat/newsboat.git"

    depends_on "asciidoc" => :build
    depends_on "docbook-xsl" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "json-c"
  depends_on "libstfl"

  needs :cxx11

  def install
    ENV["XML_CATALOG_FILES"] = "/usr/local/etc/xml/catalog" if build.head?
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"urls.txt").write "https://github.com/blog/subscribe"
    assert_match /newsboat - Exported Feeds/m, shell_output("LC_ALL=C #{bin}/newsboat -e -u urls.txt")
  end
end
