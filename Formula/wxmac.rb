class Wxmac < Formula
  desc "Cross-platform C++ GUI toolkit (wxWidgets for macOS)"
  homepage "https://www.wxwidgets.org"
  url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.0.4/wxWidgets-3.0.4.tar.bz2"
  sha256 "96157f988d261b7368e5340afa1a0cad943768f35929c22841f62c25b17bf7f0"
  revision 2
  head "https://github.com/wxWidgets/wxWidgets.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b8fa4a72afc2121106cc19de04d7259832a2157683292939b77d39a3d7ed24bc" => :catalina
    sha256 "9c77547fb5c54e30e1db0141de431015110f270c1df5019e7976edf2aa88e7ce" => :mojave
    sha256 "e5d6efdec28764fd0ccf09f4c31d1942d526dc3d67de87f86bfa1b86375b0173" => :high_sierra
  end

  devel do
    url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.3/wxWidgets-3.1.3.tar.bz2"
    sha256 "fffc1d34dac54ff7008df327907984b156c50cff5a2f36ee3da6052744ab554a"
  end

  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  stable do
    # Adjust assertion which fails for wxGLCanvas due to changes in macOS 10.14.
    # Patch taken from upstream WX_3_0_BRANCH:
    # https://github.com/wxWidgets/wxWidgets/commit/531fdbcb64b265e6f24f1f0cc7469f308b9fb697
    patch :DATA
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "--enable-clipboard",
      "--enable-controls",
      "--enable-dataviewctrl",
      "--enable-display",
      "--enable-dnd",
      "--enable-graphics_ctx",
      "--enable-std_string",
      "--enable-svg",
      "--enable-unicode",
      "--enable-webkit",
      "--with-expat",
      "--with-libjpeg",
      "--with-libpng",
      "--with-libtiff",
      "--with-opengl",
      "--with-osx_cocoa",
      "--with-zlib",
      "--disable-precomp-headers",
      # This is the default option, but be explicit
      "--disable-monolithic",
      # Set with-macosx-version-min to avoid configure defaulting to 10.5
      "--with-macosx-version-min=#{MacOS.version}",
    ]

    system "./configure", *args
    system "make", "install"

    # wx-config should reference the public prefix, not wxmac's keg
    # this ensures that Python software trying to locate wxpython headers
    # using wx-config can find both wxmac and wxpython headers,
    # which are linked to the same place
    inreplace "#{bin}/wx-config", prefix, HOMEBREW_PREFIX
  end

  test do
    system bin/"wx-config", "--libs"
  end
end

__END__
--- a/src/osx/carbon/dcclient.cpp
+++ b/src/osx/carbon/dcclient.cpp
@@ -189,10 +189,20 @@ wxPaintDCImpl::wxPaintDCImpl( wxDC *owner )
 {
 }

+#if wxDEBUG_LEVEL
+static bool IsGLCanvas( wxWindow * window )
+{
+    // If the wx gl library isn't loaded then ciGLCanvas will be NULL.
+    static const wxClassInfo* const ciGLCanvas = wxClassInfo::FindClass("wxGLCanvas");
+    return ciGLCanvas && window->IsKindOf(ciGLCanvas);
+}
+#endif
+
 wxPaintDCImpl::wxPaintDCImpl( wxDC *owner, wxWindow *window ) :
     wxWindowDCImpl( owner, window )
 {
-    wxASSERT_MSG( window->MacGetCGContextRef() != NULL, wxT("using wxPaintDC without being in a native paint event") );
+    // With macOS 10.14, wxGLCanvas windows have a NULL CGContextRef.
+    wxASSERT_MSG( window->MacGetCGContextRef() != NULL || IsGLCanvas(window), wxT("using wxPaintDC without being in a native paint event") );
     wxPoint origin = window->GetClientAreaOrigin() ;
     m_window->GetClientSize( &m_width , &m_height);
     SetDeviceOrigin( origin.x, origin.y );
