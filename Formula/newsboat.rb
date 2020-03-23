class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://newsboat.org/releases/2.19/newsboat-2.19.tar.xz"
  sha256 "ba484c825bb903daf6d33d55126107b59e41111b455d368362208f1825403d1b"
  head "https://github.com/newsboat/newsboat.git"

  bottle do
    sha256 "1199295ca246920d89de29d40e2ff0a81c981439a3645d08face93ebfba9cede" => :catalina
    sha256 "777928ebf13a5713d9ac5f3111e55cd1e60c7114cc79457a4958c29ebc58d719" => :mojave
    sha256 "c3f36bfbd1d7d2977aa84a958f59d5d18864ea00c600ca0d180ab22604d1945e" => :high_sierra
  end

  depends_on "asciidoc" => :build
  depends_on "asciidoctor" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "gettext"
  depends_on "json-c"
  depends_on "libstfl"

  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  # fixed some compilation warnings, should be removed in the next release
  patch do
    url "https://github.com/newsboat/newsboat/pull/828.patch?full_index=1"
    sha256 "48774ce0a552bfca38b0aba82d68f4f69737a049b9c0c7733dd8c36cf3113c6c"
  end

  def install
    gettext = Formula["gettext"]

    ENV["GETTEXT_BIN_DIR"] = gettext.opt_bin.to_s
    ENV["GETTEXT_LIB_DIR"] = gettext.lib.to_s
    ENV["GETTEXT_INCLUDE_DIR"] = gettext.include.to_s
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"urls.txt").write "https://github.com/blog/subscribe"
    assert_match /newsboat - Exported Feeds/m, shell_output("LC_ALL=C #{bin}/newsboat -e -u urls.txt")
  end
end
