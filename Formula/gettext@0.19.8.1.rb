class GettextAT01981 < Formula
    desc "GNU internationalization (i18n) and localization (l10n) library"
    homepage "https://www.gnu.org/software/gettext/"
    url "https://ftp.gnu.org/gnu/gettext/gettext-0.19.8.1.tar.xz"
    mirror "https://ftpmirror.gnu.org/gettext/gettext-0.19.8.1.tar.xz"
    sha256 "105556dbc5c3fbbc2aa0edb46d22d055748b6f5c7cd7a8d99f8e7eb84e938be4"
  
    bottle do
    sha256 "4b962b73f5df156043f4b7dc08703a5b51dbe547b946814051e9f0afeac76d31" => :catalina
    sha256 "0cc8e430af3e6f2baf1c67e8ad96bea774728b5a4c2039c928d09b46643ccb22" => :mojave
    sha256 "37a07166bd326b641c272f04a5b57f7eadf484915cc057530ce50e3219d7ed4e" => :high_sierra
  end
  
    keg_only :shadowed_by_macos,
      "macOS provides the BSD gettext library & some software gets confused if both are in the library path"
  
    # https://savannah.gnu.org/bugs/index.php?46844
    depends_on "libxml2" if MacOS.version <= :mountain_lion
  
    def install
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--disable-debug",
                            "--prefix=#{prefix}",
                            "--with-included-gettext",
                            "--with-included-glib",
                            "--with-included-libcroco",
                            "--with-included-libunistring",
                            "--with-emacs",
                            "--with-lispdir=#{elisp}",
                            "--disable-java",
                            "--disable-csharp",
                            # Don't use VCS systems to create these archives
                            "--without-git",
                            "--without-cvs",
                            "--without-xz"
      system "make"
      ENV.deparallelize # install doesn't support multiple make jobs
      system "make", "install"
    end
  
    test do
      system bin/"gettext", "test"
    end
  end
  