class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://www.abisource.com/projects/link-grammar/"
  url "https://www.abisource.com/downloads/link-grammar/5.7.0/link-grammar-5.7.0.tar.gz"
  sha256 "2679921766ca3981d8663338405967df701bfaeeb3f7194219db94990cd9612a"

  bottle do
    sha256 "6ef0644cfe86218e8b5dabc359958ee64addfa480750e9658452c01859c61cf1" => :catalina
  end

  depends_on "ant" => :build
  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    ENV["PYTHON_LIBS"] = "-undefined dynamic_lookup"
    inreplace "bindings/python/Makefile.am",
      "$(PYTHON2_LDFLAGS) -module -no-undefined",
      "$(PYTHON2_LDFLAGS) -module"
    inreplace "bindings/java/build.xml.in",
      "<property name=\"source\" value=\"1.6\"/>",
      "<property name=\"source\" value=\"1.7\"/>"
    inreplace "bindings/java/build.xml.in",
      "<property name=\"target\" value=\"1.6\"/>",
      "<property name=\"target\" value=\"1.7\"/>"
    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/link-parser", "--version"
  end
end
