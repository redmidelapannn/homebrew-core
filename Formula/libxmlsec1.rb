class Libxmlsec1 < Formula
  desc "XML security library"
  homepage "https://www.aleksey.com/xmlsec/"
  url "https://www.aleksey.com/xmlsec/download/xmlsec1-1.2.27.tar.gz"
  sha256 "97d756bad8e92588e6997d2227797eaa900d05e34a426829b149f65d87118eb6"

  bottle do
    cellar :any
    rebuild 1
    sha256 "baad76cbaacac5298b717c06b65cc5904834c8c85ee7578d33dd5a5d9e0a1d11" => :mojave
    sha256 "d1fb8ef639c51ab94ef55c8dc56f18e285be13e11c75afc609f5f254d78a952f" => :high_sierra
    sha256 "1531fa0dbe9000b7072b4dce711c082b098d2a45963ae64e6a5197dcccb4fd2f" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls" # Yes, it wants both ssl/tls variations
  depends_on "libgcrypt"
  depends_on "libxml2" if MacOS.version <= :lion
  depends_on "openssl"

  # Add HOMEBREW_PREFIX/lib to dl load path
  patch :DATA

  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--disable-crypto-dl",
            "--disable-apps-crypto-dl",
            "--with-openssl=#{Formula["openssl"].opt_prefix}"]

    args << "--with-libxml=#{Formula["libxml2"].opt_prefix}" if MacOS.version <= :lion

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
