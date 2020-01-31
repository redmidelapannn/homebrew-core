class John < Formula
  desc "Featureful UNIX password cracker"
  homepage "https://www.openwall.com/john/"
  url "https://www.openwall.com/john/k/john-1.9.0.tar.xz"
  sha256 "0b266adcfef8c11eed690187e71494baea539efbd632fe221181063ba09508df"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "88e7b8b3dbb79947dbbc1822a29d24c80dd5f6fbcd46c8d1a5479b5e80d84662" => :catalina
    sha256 "c2cafb624da5756897b57e612cadb74fe591ed1852495cd94847863296af29a4" => :mojave
    sha256 "61a27e5e70856387eddeab69cd77828c59b400de62f88dd497663c3ac6038f5f" => :high_sierra
  end

  conflicts_with "john-jumbo", :because => "both install the same binaries"

  patch :DATA # Taken from MacPorts, tells john where to find runtime files

  def install
    ENV.deparallelize

    system "make", "-C", "src", "clean", "CC=#{ENV.cc}", "macosx-x86-64"

    prefix.install "doc/README"
    doc.install Dir["doc/*"]

    # Only symlink the binary into bin
    libexec.install Dir["run/*"]
    bin.install_symlink libexec/"john"

    share.install_symlink libexec => "john"
  end
end


__END__
--- a/src/params.h	2012-08-30 13:24:18.000000000 -0500
+++ b/src/params.h	2012-08-30 13:25:13.000000000 -0500
@@ -70,15 +70,15 @@
  * notes above.
  */
 #ifndef JOHN_SYSTEMWIDE
-#define JOHN_SYSTEMWIDE			0
+#define JOHN_SYSTEMWIDE			1
 #endif
 
 #if JOHN_SYSTEMWIDE
 #ifndef JOHN_SYSTEMWIDE_EXEC /* please refer to the notes above */
-#define JOHN_SYSTEMWIDE_EXEC		"/usr/libexec/john"
+#define JOHN_SYSTEMWIDE_EXEC		"HOMEBREW_PREFIX/share/john"
 #endif
 #ifndef JOHN_SYSTEMWIDE_HOME
-#define JOHN_SYSTEMWIDE_HOME		"/usr/share/john"
+#define JOHN_SYSTEMWIDE_HOME		"HOMEBREW_PREFIX/share/john"
 #endif
 #define JOHN_PRIVATE_HOME		"~/.john"
 #endif
