class Efl < Formula
  desc "Enlightenment Foundation Libraries"
  homepage "https://www.enlightenment.org"
  url "https://download.enlightenment.org/rel/libs/efl/efl-1.22.4.tar.xz"
  sha256 "454002b98922f5590048ff523237c41f93d8ab0a76174be167dea0677c879120"
  revision 1

  bottle do
    sha256 "6ace0009472b25853593bc67591ea01a217ffdbcb7624df5144a4a3bef211294" => :catalina
    sha256 "82e741c9658b0e3b54374a6585f48350bdc34b7563fa87f19928446ece38d42c" => :mojave
    sha256 "cc8ec892c25c2b450d2d6f8bbb62e28ca8be26a6614e775b7f7be7e4ef58f2ee" => :high_sierra
  end

  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "bullet"
  depends_on "dbus"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "giflib"
  depends_on "gst-plugins-good"
  depends_on "gstreamer"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libsndfile"
  depends_on "libspectre"
  depends_on "libtiff"
  depends_on "luajit"
  depends_on "openssl@1.1"
  depends_on "poppler"
  depends_on "pulseaudio"
  depends_on "shared-mime-info"

  # https://phab.enlightenment.org/T8562
  patch :DATA

  def install
    ENV.cxx11

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  def post_install
    system Formula["shared-mime-info"].opt_bin/"update-mime-database", "#{HOMEBREW_PREFIX}/share/mime"
  end

  test do
    system bin/"edje_cc", "-V"
    system bin/"eet", "-V"
  end
end

__END__
diff --git a/src/lib/ecore_cocoa/ecore_cocoa_app.m b/src/lib/ecore_cocoa/ecore_cocoa_app.m
index 8df1be1..e29b934 100644
--- a/src/lib/ecore_cocoa/ecore_cocoa_app.m
+++ b/src/lib/ecore_cocoa/ecore_cocoa_app.m
@@ -45,7 +45,7 @@ + (Ecore_Cocoa_Application *)sharedApplication
 
 - (void)internalUpdate
 {
-   [_mainMenu update];
+   [[self mainMenu] update];
    // FIXME Will not compile with GNUStep (member is named "_main_menu")
 }
 
@@ -76,7 +76,7 @@ - (void)run
 {
    [self finishLaunching];
 
-   _running = 1;
+   [self setValue:[NSNumber numberWithShort:1] forKey:@"_running"];
    _expiration = [NSDate distantPast];
 
    _timer = ecore_timer_add(ECORE_COCOA_MAINLOOP_PERIOD,
