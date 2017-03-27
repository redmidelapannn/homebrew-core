class Devtodo < Formula
  desc "Command-line task lists"
  homepage "https://swapoff.org/devtodo.html"
  url "https://swapoff.org/files/devtodo/devtodo-0.1.20.tar.gz"
  sha256 "379c6ac4499fc97e9676075188f7217e324e7ece3fb6daeda7bf7969c7093e09"
  revision 1

  bottle do
    rebuild 1
    sha256 "2b0d56cca2992dc47d8482a9e593814c5efe2037888fd0b5dcfde42b96115c6f" => :sierra
    sha256 "067a0292776f3818e70bc446fe4c3205ae1bb3911bc97e7adc96376e2fadfae5" => :el_capitan
    sha256 "2068a5bfd5f39d62d8b9246b4da0d8b9846ac1797d9f1b0c9d05f54db1b292a2" => :yosemite
  end

  depends_on "readline"

  # Fix invalid regex. See http://swapoff.org/ticket/54
  # @adamv - this url not responding 3/17/2012
  patch :DATA

  def install
    # Rename Regex.h to Regex.hh to avoid case-sensitivity confusion with regex.h
    mv "util/Regex.h", "util/Regex.hh"
    inreplace ["util/Lexer.h", "util/Makefile.in", "util/Regex.cc"],
      "Regex.h", "Regex.hh"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
    doc.install "contrib"
  end
end

__END__
--- a/util/XML.cc	Mon Dec 10 22:26:55 2007
+++ b/util/XML.cc	Mon Dec 10 22:27:07 2007
@@ -49,7 +49,7 @@ void XML::init() {
 	// Only initialise scanners once
 	if (!initialised) {
 		// <?xml version="1.0" encoding="UTF-8" standalone="no"?>
-		xmlScan.addPattern(XmlDecl, "<\\?xml.*?>[[:space:]]*");
+		xmlScan.addPattern(XmlDecl, "<\\?xml.*\\?>[[:space:]]*");
 		xmlScan.addPattern(XmlCommentBegin, "<!--");
 		xmlScan.addPattern(XmlBegin, "<[a-zA-Z0-9_-]+"
 			"([[:space:]]+[a-zA-Z_0-9-]+=(([/a-zA-Z_0-9,.]+)|(\"[^\"]*\")|('[^']*')))"
