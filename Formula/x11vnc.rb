class X11vnc < Formula
  desc "VNC server for real X displays"
  homepage "http://www.karlrunge.com/x11vnc/"
  url "https://downloads.sourceforge.net/project/libvncserver/x11vnc/0.9.13/x11vnc-0.9.13.tar.gz"
  sha256 "f6829f2e629667a5284de62b080b13126a0736499fe47cdb447aedb07a59f13b"

  bottle do
    cellar :any
    revision 1
    sha256 "53d6e8f03f6702932110778780e1a1323e0f1335abab5500460ccd31ec17575b" => :el_capitan
    sha256 "dc294ec933c251be58f36c909e618d88aeb17890b48386819ab49fafbe155c0e" => :yosemite
    sha256 "269de3c18be607b2e121556b62deb0b3e3debfe5be6af2e52678715b4aea90cd" => :mavericks
  end

  depends_on :x11 => :optional
  depends_on "openssl"
  depends_on "jpeg"

  # Patch solid.c so a non-void function returns a NULL instead of a void.
  # An email has been sent to the maintainers about this issue.
  patch :DATA

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    if build.with? "x11"
      args << "--with-x"
    else
      args << "--without-x"
    end

    system "./configure", *args
    system "make"
    system "make", "MKDIRPROG=mkdir -p", "install"
  end

  test do
    system bin/"x11vnc", "--version"
  end
end

__END__
diff --git a/x11vnc/solid.c b/x11vnc/solid.c
index d6b0bda..0b2cfa9 100644
--- a/x11vnc/solid.c
+++ b/x11vnc/solid.c
@@ -177,7 +177,7 @@ unsigned long get_pixel(char *color) {
 
 XImage *solid_root(char *color) {
 #if NO_X11
-	RAWFB_RET_VOID
+	RAWFB_RET(NULL)
 	if (!color) {}
 	return NULL;
 #else
