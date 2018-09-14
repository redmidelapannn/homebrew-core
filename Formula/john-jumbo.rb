class JohnJumbo < Formula
  desc "Enhanced version of john, a UNIX password cracker"
  homepage "https://www.openwall.com/john/"
  url "https://openwall.com/john/j/john-1.8.0-jumbo-1.tar.xz"
  version "1.8.0"
  sha256 "bac93d025995a051f055adbd7ce2f1975676cac6c74a6c7a3ee4cfdd9c160923"

  bottle do
    cellar :any
    rebuild 7
    sha256 "8875fa3891d8266d52af3547d4c54448c16269f0730ecdfa5026c2d1e74d1629" => :mojave
    sha256 "40b5aee653fd60a1c4727f5d1a26ccbb8e33c2f597886dfc888eec1ddf8bd0e4" => :high_sierra
    sha256 "a343522beaa867616f532191e59b8607d10a619be30975ec8f223172791f6f17" => :sierra
    sha256 "aff625d87f50766e4a2250f58ebe2aac211a71a3ac98ca09d96c086171b16dae" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "gmp"

  conflicts_with "john", :because => "both install the same binaries"

  # Patch taken from MacPorts, tells john where to find runtime files.
  # https://github.com/magnumripper/JohnTheRipper/issues/982
  patch :DATA

  # https://github.com/magnumripper/JohnTheRipper/blob/bleeding-jumbo/doc/INSTALL#L133-L143
  fails_with :gcc do
    cause "Upstream have a hacky workaround for supporting gcc that we can't use."
  end

  # Previously john-jumbo ignored the value of $HOME; fixed
  # upstream.  See
  # https://github.com/magnumripper/JohnTheRipper/issues/1901
  patch do
    url "https://github.com/magnumripper/JohnTheRipper/commit/d29ad8aabaa9726eb08f440001c37611fa072e0c.diff?full_index=1"
    sha256 "b3400f54c64dccce6fe4846872c945b280ec221c7a3d614b03c18029cba3695a"
  end

  def install
    cd "src" do
      args = []
      if build.bottle?
        args << "--disable-native-tests" << "--disable-native-macro"
      end
      system "./configure", *args
      system "make", "clean"
      system "make", "-s", "CC=#{ENV.cc}"
    end

    # Remove the symlink and install the real file
    rm "README"
    prefix.install "doc/README"
    doc.install Dir["doc/*"]

    # Only symlink the main binary into bin
    (share/"john").install Dir["run/*"]
    bin.install_symlink share/"john/john"

    bash_completion.install share/"john/john.bash_completion" => "john.bash"
    zsh_completion.install share/"john/john.zsh_completion" => "_john"

    # Source code defaults to "john.ini", so rename
    mv share/"john/john.conf", share/"john/john.ini"
  end

  test do
    touch "john2.pot"
    (testpath/"test").write "dave:#{`printf secret | /usr/bin/openssl md5`}"
    assert_match(/secret/, shell_output("#{bin}/john --pot=#{testpath}/john2.pot --format=raw-md5 test"))
    assert_match(/secret/, (testpath/"john2.pot").read)
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
