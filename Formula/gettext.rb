class Gettext < Formula
  desc "GNU internationalization (i18n) and localization (l10n) library"
  homepage "https://www.gnu.org/software/gettext/"
  url "https://ftp.gnu.org/gnu/gettext/gettext-0.20.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gettext/gettext-0.20.1.tar.xz"
  sha256 "53f02fbbec9e798b0faaf7c73272f83608e835c6288dd58be6c9bb54624a3800"

  bottle do
    rebuild 1
    sha256 "6354adfc22f1d78b1a671862db906ff1e55482be9c58a6ee6a43245f8895fef2" => :catalina
    sha256 "3e78cfbfb76171b45ea5a607696cd2ba9528774d254b33356694570824a7b93b" => :mojave
    sha256 "56a45a0903efb1fd250c66a87ad076aba604462ba344a855c940f2e3223a8373" => :high_sierra
  end

  keg_only :shadowed_by_macos,
    "macOS provides the BSD gettext library & some software gets confused if both are in the library path"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-included-gettext",
                          # Work around a gnulib issue with macOS Catalina
                          "gl_cv_func_ftello_works=yes",
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
