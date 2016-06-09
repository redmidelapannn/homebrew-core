class Pulseaudio < Formula
  desc "Sound system for POSIX OSes"
  homepage "https://wiki.freedesktop.org/www/Software/PulseAudio/"
  url "https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-8.0.tar.xz"
  sha256 "690eefe28633466cfd1ab9d85ebfa9376f6b622deec6bfee5091ac9737cd1989"

  bottle do
    revision 2
    sha256 "6745e4f7b6651ace50df7e680a04508e49895f0f82e5c82cdae2e030dfc8d3f7" => :el_capitan
    sha256 "34e4a7e81ce484406aa3f7843efc592a1891db0ae0a77d71ec9c1ea010603206" => :yosemite
    sha256 "5b1784a451de2290b39be8fff139d87e82b08bf79888e5bc401ea2eda42d38aa" => :mavericks
  end

  head do
    url "https://anongit.freedesktop.org/git/pulseaudio/pulseaudio.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "intltool" => :build
    depends_on "gettext" => :build
  end

  option "with-nls", "Build with native language support"
  option :universal

  depends_on "pkg-config" => :build

  if build.with? "nls"
    depends_on "intltool" => :build
    depends_on "gettext" => :build
  end

  depends_on "libtool" => :run
  depends_on "json-c"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "openssl"

  depends_on :x11 => :optional
  depends_on "glib" => :optional
  depends_on "gconf" => :optional
  depends_on "dbus" => :optional
  depends_on "gtk+3" => :optional
  depends_on "jack" => :optional

  # i386 patch per MacPorts
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/15fa4f03/pulseaudio/i386.patch"
    sha256 "d3a2180600a4fbea538949b6c4e9e70fe7997495663334e50db96d18bfb1da5f"
  end

  # Fix CoreServices header location check in configure for Xcode-only
  # https://bugs.freedesktop.org/show_bug.cgi?id=55152
  patch :DATA

  fails_with :clang do
    build 421
    cause "error: thread-local storage is unsupported for the current target"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-coreaudio-output
      --disable-neon-opt
      --with-mac-sysroot=/
    ]

    args << "--with-mac-sysroot=#{MacOS.sdk_path}"
    args << "--with-mac-version-min=#{MacOS.version}"
    args << "--disable-nls" if build.without? "nls"

    if build.universal?
      args << "--enable-mac-universal"
      ENV.universal_binary
    end

    if build.head?
      # autogen.sh runs bootstrap.sh then ./configure
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    system bin/"pulseaudio", "--dump-modules"
  end
end

__END__
diff --git a/configure b/configure
index a3c0fa4..39a7da8 100755
--- a/configure
+++ b/configure
@@ -22314,29 +22314,14 @@ fi
 if test "x$os_is_darwin" = "x1" ; then
     { $as_echo "$as_me:${as_lineno-$LINENO}: checking looking for Apple CoreService Framework" >&5
 $as_echo_n "checking looking for Apple CoreService Framework... " >&6; }
-    # How do I check a framework "library" - AC_CHECK_LIB prob. won't work??, just assign LIBS & hope
-    ac_fn_c_check_header_mongrel "$LINENO" "/Developer/Headers/FlatCarbon/CoreServices.h" "ac_cv_header__Developer_Headers_FlatCarbon_CoreServices_h" "$ac_includes_default"
-if test "x$ac_cv_header__Developer_Headers_FlatCarbon_CoreServices_h" = xyes; then :
+    ac_fn_c_check_header_mongrel "$LINENO" "CoreServices/CoreServices.h" "ac_cv_header_CoreServices_CoreServices_h" "$ac_includes_default"
+if test "x$ac_cv_header_CoreServices_CoreServices_h" = xyes; then :
   LIBS="$LIBS -framework CoreServices"
 else
-  for ac_header in /System/Library/Frameworks/CoreServices.framework/Headers/CoreServices.h
-do :
-  ac_fn_c_check_header_mongrel "$LINENO" "/System/Library/Frameworks/CoreServices.framework/Headers/CoreServices.h" "ac_cv_header__System_Library_Frameworks_CoreServices_framework_Headers_CoreServices_h" "$ac_includes_default"
-if test "x$ac_cv_header__System_Library_Frameworks_CoreServices_framework_Headers_CoreServices_h" = xyes; then :
-  cat >>confdefs.h <<_ACEOF
-#define HAVE__SYSTEM_LIBRARY_FRAMEWORKS_CORESERVICES_FRAMEWORK_HEADERS_CORESERVICES_H 1
-_ACEOF
- LIBS="$LIBS -framework CoreServices"
-else
   as_fn_error $? "CoreServices.h header file not found" "$LINENO" 5

 fi

-done
-
-
-fi
-


     { $as_echo "$as_me:${as_lineno-$LINENO}: result: ok" >&5
