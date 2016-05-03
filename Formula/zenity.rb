class Zenity < Formula
  desc "GTK+ dialog boxes for the command-line"
  homepage "https://live.gnome.org/Zenity"
  url "https://download.gnome.org/sources/zenity/3.18/zenity-3.18.1.tar.xz"
  sha256 "089d45f8e82bb48ae80fcb78693bcd7a29579631234709d752afed6c5a107ba8"

  bottle do
    revision 1
    sha256 "9bcf0800c03545b536c5bb02af16cec6831bfe3c80e53adea6b69a8ec3ecff71" => :el_capitan
    sha256 "59c5f2690281de85d299dd974be9d8b310fd4743a2406b216b120df44f2026e2" => :yosemite
    sha256 "bf8d506fa70116a0863c129255760666514795608f530ff3de321f702747ae9e" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libxml2"
  depends_on "gtk+3"
  depends_on "gnome-doc-utils"
  depends_on "scrollkeeper"
  depends_on "webkitgtk" => :recommended
  depends_on "libnotify" => :optional

  # submitted upstream at https://bugzilla.gnome.org/show_bug.cgi?id=756756
  patch :DATA

  def install
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/zenity", "--help"
  end
end

__END__
diff --git a/src/option.c b/src/option.c
index 79a6f92..246cf22 100644
--- a/src/option.c
+++ b/src/option.c
@@ -2074,9 +2074,11 @@ zenity_text_post_callback (GOptionContext *context,
     if (zenity_text_font)
       zenity_option_error (zenity_option_get_name (text_options, &zenity_text_font),
                            ERROR_SUPPORT);
+#ifdef HAVE_WEBKITGTK
     if (zenity_text_enable_html)
       zenity_option_error (zenity_option_get_name (text_options, &zenity_text_enable_html),
                            ERROR_SUPPORT);
+#endif
   }
   return TRUE;
 }
