class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://newsboat.org/releases/2.16.1/newsboat-2.16.1.tar.xz"
  sha256 "4023c817b36fc08a3191283eec2c7161949c0727633f60ad837e11c599d3ad53"
  head "https://github.com/newsboat/newsboat.git"

  bottle do
    rebuild 1
    sha256 "d48afac5dabd0751b3b1ef33b9e743df4d57b64120f3b0651573031b2103a727" => :mojave
    sha256 "e6d09b00e15e418f383b660316891f38aff630c88efd0fe887793c12f6e0bdbc" => :high_sierra
    sha256 "10a25b47e17175ef3dbdef828a1e410071b60c08ff9896be7ae8849fdcc54af9" => :sierra
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "gettext"
  depends_on "json-c"
  depends_on "libstfl"
  uses_from_macos "libxml2"

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
