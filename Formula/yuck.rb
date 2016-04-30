class Yuck < Formula
  desc "Bog-standard command-line option parser for C"
  homepage "http://www.fresse.org/yuck/"
  url "https://github.com/hroptatyr/yuck/releases/download/v0.2.2/yuck-0.2.2.tar.xz"
  sha256 "9cd0c1af9a4afe6002f1672c8ece91d305cea1f61fbc07c7ce94a0bbe634deec"

  bottle do
    sha256 "1807841bba67f59266f588fc1fdc8f00f1d793cb2f44891c671c7decd79bdead" => :el_capitan
    sha256 "d8885a5e8994f42b3e2e752fadd1916054a54ef31beb9657be0fac59d55ccc85" => :yosemite
    sha256 "a88f11dca44f5924fc9997917c4666b230fa7db2f98dbd84449319f8e008aa14" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.yuck").write("Usage: foo")
    system "#{bin}/yuck", "gen", "test.yuck"
  end

  patch :p0, :DATA
end
__END__
diff --git src/config.h.in src/config.h.in
index 5ad9fbf..25712c2 100644
--- src/config.h.in
+++ src/config.h.in
@@ -86,3 +86,5 @@

 /* m4 value used for yuck build */
 #undef YUCK_M4
+
+#define YUCK_TEMPLATE_PATH "HOMEBREW_PREFIX/Cellar/yuck/0.2.2/share/yuck"
