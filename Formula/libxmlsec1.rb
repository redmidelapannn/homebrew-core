class Libxmlsec1 < Formula
  desc "XML security library"
  homepage "https://www.aleksey.com/xmlsec/"
  url "https://www.aleksey.com/xmlsec/download/xmlsec1-1.2.26.tar.gz"
  sha256 "8d8276c9c720ca42a3b0023df8b7ae41a2d6c5f9aa8d20ed1672d84cc8982d50"

  bottle do
    rebuild 1
    sha256 "45ec774b0a305fb02da57bc9e6d8209186d1df465401ca432426518efa95cb19" => :high_sierra
    sha256 "9d60c145615fef403e15e5ed09648e940210826396298f8b4ac3d05d84434d1e" => :sierra
    sha256 "16478d2e391714adad9bd146abf736c28267ae5a8ce9b37e02216e62b0b8c4a5" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libxml2" if MacOS.version <= :lion

  # Yes, it wants both ssl/tls variations.
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "openssl"

  # Add HOMEBREW_PREFIX/lib to dl load path
  patch :DATA

  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--disable-crypto-dl",
            "--disable-apps-crypto-dl",
            "--with-openssl=#{Formula["openssl"].opt_prefix}"]

    args << "--with-libxml=#{Formula["libxml2"].opt_prefix}" if build.with? "libxml2"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/xmlsec1", "--version"
    system "#{bin}/xmlsec1-config", "--version"
  end
end

__END__
diff --git a/src/dl.c b/src/dl.c
index 6e8a56a..0e7f06b 100644
--- a/src/dl.c
+++ b/src/dl.c
@@ -141,6 +141,7 @@ xmlSecCryptoDLLibraryCreate(const xmlChar* name) {
     }

 #ifdef XMLSEC_DL_LIBLTDL
+    lt_dlsetsearchpath("HOMEBREW_PREFIX/lib");
     lib->handle = lt_dlopenext((char*)lib->filename);
     if(lib->handle == NULL) {
         xmlSecError(XMLSEC_ERRORS_HERE,
