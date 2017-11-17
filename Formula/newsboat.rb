class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://github.com/newsboat/newsboat/archive/r2.10.1.tar.gz"
  sha256 "82d5e3e2a6dab845aac0bf72580f46c2756375d49214905a627284e5bc32e327"
  head "https://github.com/newsboat/newsboat.git"

  bottle do
    rebuild 1
    sha256 "48a75214562ef3ef53ddf380711971e818fdb2b039860654017412d0b9cc2e07" => :high_sierra
    sha256 "9d4b3c53f92a57ed367ae97002debb1c97cd8212c6c56c674620b4c8cf9a72c5" => :sierra
    sha256 "21a5e22ab07e226de8391e8f67dcb785f34d84c4af8c21d01ca45db84aae2c2a" => :el_capitan
  end

  depends_on "asciidoc" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "json-c"
  depends_on "libstfl"

  needs :cxx11

  def install
    ENV["XML_CATALOG_FILES"] = "/usr/local/etc/xml/catalog"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"urls.txt").write "https://github.com/blog/subscribe"
    assert_match /newsboat - Exported Feeds/m, shell_output("LC_ALL=C #{bin}/newsboat -e -u urls.txt")
  end
end
