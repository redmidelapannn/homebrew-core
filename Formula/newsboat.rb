class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://github.com/newsboat/newsboat/archive/r2.10.2.tar.gz"
  sha256 "e548596d3a263369210890f46f146a6a398bd2b1973f94167e5614dee58ab7aa"
  head "https://github.com/newsboat/newsboat.git"

  bottle do
    rebuild 1
    sha256 "4bdf02a93f70cc8137fd247f53599f5dd39d47987132c7497ec40b93e76398c4" => :high_sierra
    sha256 "089fc63d75b13b450762b6d59722ad8d75d82d082747eda3041a0892c60c9ecb" => :sierra
    sha256 "351ef2f1bfa8b5767fc56e4484cebd711c00274a01e850c4b76f042d42998e4d" => :el_capitan
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "json-c"
  depends_on "libstfl"

  needs :cxx11

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"urls.txt").write "https://github.com/blog/subscribe"
    assert_match /newsboat - Exported Feeds/m, shell_output("LC_ALL=C #{bin}/newsboat -e -u urls.txt")
  end
end
