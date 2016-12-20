class Gettext < Formula
  desc "GNU internationalization (i18n) and localization (l10n) library"
  homepage "https://www.gnu.org/software/gettext/"
  url "https://ftpmirror.gnu.org/gettext/gettext-0.19.8.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gettext/gettext-0.19.8.1.tar.xz"
  sha256 "105556dbc5c3fbbc2aa0edb46d22d055748b6f5c7cd7a8d99f8e7eb84e938be4"

  bottle do
    rebuild 1
    sha256 "1f4ef8951cc4286d1c4478a929a35d370d0e06aa6e145a7b53990bd608f0919e" => :sierra
    sha256 "ac98bf56bc439322b8fd8c2dba0b4a76d7ff4997410d39bd1ef201d6014d9589" => :el_capitan
    sha256 "40ab4bd9d1028f01ea1c9bbf8195bdf7dd857b9142b012b51d222435da8786bf" => :yosemite
  end

  keg_only :shadowed_by_osx, "macOS provides the BSD gettext library and some software gets confused if both are in the library path."

  option :universal

  # https://savannah.gnu.org/bugs/index.php?46844
  depends_on "libxml2" if MacOS.version <= :mountain_lion

  def install
    ENV.universal_binary if build.universal?

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
